//
//  IBConnection.swift
//    IBKit
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//

import NIOCore

class IBClientFrameDecoder: ByteToMessageDecoder & NIOSingleStepByteToMessageDecoder {
    typealias InboundIn = ByteBuffer
    typealias InboundOut = ByteBuffer
    
    private var lastScanOffset = 0
    
    func decode(context: ChannelHandlerContext, buffer: inout ByteBuffer) throws -> DecodingState {
        if let frame = try self.readFrame(buffer: &buffer) {
            context.fireChannelRead(wrapInboundOut(frame))
            return .continue
        } else {
            return .needMoreData
        }
    }

    func decode(buffer: inout NIOCore.ByteBuffer) throws -> NIOCore.ByteBuffer? {
        return try self.readFrame(buffer: &buffer)
    }

    func decodeLast(context: ChannelHandlerContext, buffer: inout ByteBuffer, seenEOF: Bool) throws -> DecodingState {
        while try self.decode(context: context, buffer: &buffer) == .continue {}
        if buffer.readableBytes > 0 {
            context.fireErrorCaught(IBError.failedToRead("leftover bytes"))
        }
        return .needMoreData
    }

    func decodeLast(buffer: inout ByteBuffer, seenEOF: Bool) throws -> InboundOut? {
        let decoded = try self.decode(buffer: &buffer)
        if buffer.readableBytes > 0 {
            throw IBError.failedToRead("leftover bytes")
        }
        return decoded
    }

    private func readFrame(buffer: inout ByteBuffer) throws -> ByteBuffer? {
        // Using readableBytesView with lastScanOffset to avoid re-scanning bytes that have already been checked
        let view = buffer.readableBytesView.dropFirst(self.lastScanOffset)

        // Ensure there are at least 4 bytes available to read the length prefix after the offset
        if view.count < 4 {
            return nil  // Not enough bytes to read the length of the frame, wait for more data.
        }

        // Get the length prefix from the adjusted view
        let lengthData = view.prefix(4)
        let lengthBytes = Array(lengthData)  // Copy into a new array to ensure alignment
        var lengthPrefix: Int32 = lengthBytes.withUnsafeBytes { $0.load(as: Int32.self) }
        lengthPrefix = Int32(bigEndian: lengthPrefix) // Ensure the length is read in big endian format, if necessary.

        let frameLength = Int(lengthPrefix)
        // Check if the buffer has enough bytes for the whole frame (length prefix + payload)
        if buffer.readableBytes < (frameLength + 4 + self.lastScanOffset) {
            self.lastScanOffset += view.count
            return nil  // Wait for more data to arrive
        }

        // Reset lastScanOffset as we are about to read a full message
        self.lastScanOffset = 0

        // Move the reader index past the length prefix
        buffer.moveReaderIndex(forwardBy: 4 + self.lastScanOffset)

        // Read the message data based on the length prefix
        let frame = buffer.readSlice(length: frameLength)

        return frame
    }

}
