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
        guard buffer.readableBytes >= 4 else {
            return nil
        }

        let lengthPrefix = buffer.getInteger(at: buffer.readerIndex, as: Int32.self)!
        let frameLength = Int(lengthPrefix.littleEndian)

        guard buffer.readableBytes >= 4 + frameLength else {
            return nil
        }

        buffer.moveReaderIndex(forwardBy: 4)
        let frame = buffer.readSlice(length: frameLength)
        return frame
    }
}
