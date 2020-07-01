//
// Created by liuyu on 7/1/20.
// Copyright (c) 2020 limit. All rights reserved.
//

#ifndef LEARN_OPEN_GL_ES_CAMERA_HPP
#define LEARN_OPEN_GL_ES_CAMERA_HPP

#import "Vector3.hpp"
#import "Matrix4.hpp"

enum CameraMovement {
    Forward,
    Backward,
    Left,
    Right,
};

const float YAW = -90.f;
const float PITCH = 0.f;
const float SPEED = 2.5f;
const float ZOOM = 45.f;

template<class S = float>
class Camera {
public:

    Vector3<S> position;
    Vector3<S> front;
    Vector3<S> up;
    Vector3<S> right;
    Vector3<S> worldUp;
    float yaw;
    float pitch;
    float movementSpeed;
    float zoom;

    Camera() {
        this->position = Vector3<float>::Zero();
        this->front = Vector3<float>(0.f, 0.f, -1.f);
        this->up = Vector3<float>::Zero();
        this->right = Vector3<float>::Zero();
        this->worldUp = Vector3<float>::unit_y();
        this->yaw = YAW;
        this->pitch = PITCH;
        this->movementSpeed = SPEED;
        this->zoom = ZOOM;
    }

    static Camera *init() {
        auto camera = new Camera();
        camera->updateCameraVectors();
        return camera;
    }

    Matrix4<float> getViewMat() {
        return Matrix4<float>::lookAt(position, (position + front), up);
    }

private:
    void updateCameraVectors() {
        front = Vector3<S>(
                cos(GLKMathDegreesToRadians(yaw)) * cos(GLKMathDegreesToRadians(pitch)),
                sin(GLKMathDegreesToRadians(pitch)),
                sin(GLKMathDegreesToRadians(yaw)) * cos(GLKMathDegreesToRadians(pitch))
        ).normalize();

        right = front.cross(worldUp).normalize();
        up = right.cross(front).normalize();
    }

};


#endif //LEARN_OPEN_GL_ES_CAMERA_HPP
