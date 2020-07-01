//
// Created by liuyu on 6/29/20.
// Copyright (c) 2020 limit. All rights reserved.
//

#ifndef LEARN_OPEN_GL_ES_VECTOR3_HPP
#define LEARN_OPEN_GL_ES_VECTOR3_HPP

const int VEC_LEN = 3;

template<typename S>
struct Vector3 {
    S x;
    S y;
    S z;

    Vector3<S>(S x_ = 0, S y_ = 0, S z_ = 0) : x(x_), y(y_), z(z_) {
    }

    static Vector3<S> Zero() {
        return Vector3(0.f, 0.f, 0.f);
    }

    static Vector3<S> unit_x() {
        return Vector3(1.f, 0.f, 0.f);
    }

    static Vector3<S> unit_y() {
        return Vector3(0.f, 1.f, 0.f);
    }

    Vector3<S> operator+(Vector3<S> b) {
        return Vector3(x + b.x, y + b.y, z + b.z);
    }

    Vector3<S> operator-(Vector3<S> b) {
        return Vector3(x - b.x, y - b.y, z - b.z);
    }

    Vector3<S> operator*(S b) {
        return Vector3(x * b, y * b, z * b);
    }

    Vector3<S> cross(Vector3<S> b) {
        return Vector3(y * b.z - z * b.y, z * b.x - x * b.z, x * b.y - y * b.x);
    }

    S dot(Vector3<S> b) {
        return x * b.x + y * b.y + z * b.z;
    }

    S *toVec() {
        S ptr[VEC_LEN] = {x, y, z};
        for (int i = 0; i < VEC_LEN; ++i) {
            vec[i] = ptr[i];
        }
        return vec;
    }

    Vector3<S> normalize() {
        const float len = std::sqrt(x * x + y * y + z * z);
        S _x = x / len;
        S _y = y / len;
        S _z = z / len;
        return Vector3(_x, _y, _z);
    }

private:
    S vec[VEC_LEN];
};

#endif //LEARN_OPEN_GL_ES_VECTOR3_HPP
