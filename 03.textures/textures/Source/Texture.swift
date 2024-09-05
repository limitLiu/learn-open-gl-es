import GLKit

struct Texture {
    var tex: GLuint?
    
    init(image: CGImage) {
        let width = image.width
        let height = image.height
        let imageData = UnsafeMutablePointer<GLubyte>.allocate(capacity: width * height * 4)
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        if let context = CGContext(data: imageData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo) {
            context.translateBy(x: 0, y: CGFloat(height))
            context.scaleBy(x: 1.0, y: -1.0)
            context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
            var textureID = GLuint()
            glGenTextures(1, &textureID)
            glBindTexture(GLenum(GL_TEXTURE_2D), textureID)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
            glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
            glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), imageData)
//            glGenerateMipmap(GLenum(GL_TEXTURE_2D))
            glBindTexture(GLenum(GL_TEXTURE_2D), 0)
            tex = textureID
        }
        imageData.deallocate()
    }
}
