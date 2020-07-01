//
//  Matrix4.hpp
//  learn-open-gl-es
//
//  Created by liuyu on 6/27/20.
//  Copyright © 2020 limit. All rights reserved.
//

#ifndef LEARN_OPEN_GL_ES_MATRIX4_HPP
#define LEARN_OPEN_GL_ES_MATRIX4_HPP

#import "Vector4.hpp"
#import "Vector3.hpp"
#import <string>

const int MAX_NUM = 4;

template<typename S>
struct Matrix4 {
    Matrix4() {
        S m[MAX_NUM][MAX_NUM] = {
                {1, 0, 0, 0},
                {0, 1, 0, 0},
                {0, 0, 1, 0},
                {0, 0, 0, 1},
        };
        setMatrix4(m);
    }

    Matrix4<S>(S mat[][MAX_NUM]) {
        memcpy(m, mat, sizeof(m));
    }

    S *getMat() {
        int k = 0;
        for (int i = 0; i < MAX_NUM; ++i) {
            for (int j = 0; j < MAX_NUM; ++j) {
                mat[k] = m[i][j];
                k++;
            }
        }
        return mat;
    }

    void setMatrix4(S mat[][MAX_NUM]) {
        memcpy(m, mat, sizeof(m));
    }

    S get(int i, int j) {
        return m[i][j];
    }

    Matrix4<S> operator*(Matrix4<S> b) {
        S mat[MAX_NUM][MAX_NUM] = {};
        for (int i = 0; i < MAX_NUM; ++i) {
            for (int j = 0; j < MAX_NUM; ++j) {
                mat[i][j] =
                        m[i][0] * b.get(0, j) +
                                m[i][1] * b.get(1, j) +
                                m[i][2] * b.get(2, j) +
                                m[i][3] * b.get(3, j);
            }
        }
        return Matrix4(mat);
    }

    Vector4<S> transform(Vector4<S> v) {
        return Vector4<S>(
                m[0][0] * v.x + m[0][1] * v.y + m[0][2] * v.z + m[0][3] * v.w,
                m[1][0] * v.x + m[1][1] * v.y + m[1][2] * v.z + m[1][3] * v.w,
                m[2][0] * v.x + m[2][1] * v.y + m[2][2] * v.z + m[2][3] * v.w,
                m[3][0] * v.x + m[3][1] * v.y + m[3][2] * v.z + m[3][3] * v.w
        );
    }

    static Matrix4<S> Identity() {
        return Matrix4<S>();
    }

    static Matrix4<S> translate(S x, S y, S z) {
        S t[MAX_NUM][MAX_NUM] = {
                {1, 0, 0, x},
                {0, 1, 0, y},
                {0, 0, 1, z},
                {0, 0, 0, 1},
        };
        return Matrix4(t);
    }

    static Matrix4<S> rotate(S x, S y, S z) {
        S mZ[MAX_NUM][MAX_NUM] = {
                {cos(z), -sin(z), 0, 0},
                {sin(z), cos(z), 0, 0},
                {0, 0, 1, 0},
                {0, 0, 0, 1},
        };

        S mY[MAX_NUM][MAX_NUM] = {
                {cos(y), 0, -sin(y), 0},
                {0, 1, 0, 0},
                {sin(y), 0, cos(y), 0},
                {0, 0, 0, 1},
        };

        S mX[MAX_NUM][MAX_NUM] = {
                {1, 0, 0, 0},
                {0, cos(x), -sin(x), 0},
                {0, sin(x), cos(x), 0},
                {0, 0, 0, 1},
        };
        return Matrix4(mX) * Matrix4(mY) * Matrix4(mZ);
    }

    static Matrix4<S> perspective(S degrees, S aspect, S near, S far) {
        S radians = tan(degrees / 2);
        S range = near - far;
        S mat[MAX_NUM][MAX_NUM] = {
                {1.0f / (radians * aspect), 0, 0, 0},
                {0, 1.0f / radians, 0, 0},
                {0, 0, (-near - far) / range, 2 * far * near / range},
                {0, 0, 1, 0},
        };
        return Matrix4(mat);
    }

    static Matrix4<S> scale(S x, S y, S z) {
        S t[MAX_NUM][MAX_NUM] = {
                {x, 0, 0, 0},
                {0, y, 0, 0},
                {0, 0, z, 0},
                {0, 0, 0, 1}
        };
        return Matrix4(t);
    }

    static Matrix4<S> lookAt(Vector3<S> eye, Vector3<S> center, Vector3<S> up) {
        return lookAtDir(eye, (center - eye), up);
    }

    static Matrix4<S> lookAtDir(Vector3<S> eye, Vector3<S> dir, Vector3<S> up) {
        auto f = dir.normalize();
        auto s = f.cross(up).normalize();
        auto u = s.cross(f);

        S t[MAX_NUM][MAX_NUM] = {
                {s.x, u.x, -f.x, 0.},
                {s.y, u.y, -f.y, 0.},
                {s.z, u.z, -f.z, 0.},
                {-eye.dot(s), -eye.dot(u), eye.dot(f), 1.}
        };
        return Matrix4(t);
    }

private:
    S m[MAX_NUM][MAX_NUM];
    S mat[MAX_NUM * MAX_NUM];

};

#endif