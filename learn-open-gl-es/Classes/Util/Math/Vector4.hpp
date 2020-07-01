//
//  Vector4.hpp
//  learn-open-gl-es
//
//  Created by liuyu on 6/27/20.
//  Copyright © 2020 limit. All rights reserved.
//


#ifndef LEARN_OPEN_GL_ES_VECTOR4_HPP
#define LEARN_OPEN_GL_ES_VECTOR4_HPP

#import <cmath>

template<typename S>
struct Vector4 {
    S x;
    S y;
    S z;
    S w;

    Vector4<S>(S x_ = 0, S y_ = 0, S z_ = 0, S w_ = 0) : x(x_), y(y_), z(z_), w(w_) {
    }

    Vector4<S> operator+(Vector4<S> b) {
        return Vector4(x + b.x, y + b.y, z + b.z, w + b.w);
    }

    Vector4<S> operator-(Vector4<S> b) {
        return Vector4(x - b.x, y - b.y, z - b.z, w - b.w);
    }

    Vector4<S> operator*(S b) {
        return Vector4(x * b, y * b, z * b, w * b);
    }

    // cross
    Vector4<S> operator*(Vector4<S> b) {
        return Vector4(y * b.z - z * b.y, z * b.x - x * b.z, x * b.y - y * b.x, w);
    }

    Vector4<S> operator/(S b) {
        return Vector4(x / b, y / b, z / b, w / b);
    }

    S dot(Vector4<S> b) {
        return x * b.x + y * b.y + z * b.z + w * b.w;
    }

    Vector4<S> normalize() {
        const float len = std::sqrt(x * x + y * y + z * z + w * w);
        S _x = x / len;
        S _y = y / len;
        S _z = z / len;
        S _w = w / len;
        return Vector4(_x, _y, _z, _w);

    }
};

#endif
