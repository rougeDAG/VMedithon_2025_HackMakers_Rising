import cv2
import mediapipe as mp
import numpy as np

# Initialize Mediapipe FaceMesh
mp_face_mesh = mp.solutions.face_mesh
face_mesh = mp_face_mesh.FaceMesh(refine_landmarks=True, max_num_faces=1)

# Start webcam
cap = cv2.VideoCapture(0)

while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = face_mesh.process(frame_rgb)

    if results.multi_face_landmarks:
        for face_landmarks in results.multi_face_landmarks:
            h, w, _ = frame.shape

            # Left & Right iris points
            left_iris = [face_landmarks.landmark[i] for i in range(474, 478)]
            right_iris = [face_landmarks.landmark[i] for i in range(469, 473)]

            # Convert to pixel coords
            left_iris_pts = np.array([(int(p.x * w), int(p.y * h)) for p in left_iris])
            right_iris_pts = np.array([(int(p.x * w), int(p.y * h)) for p in right_iris])

            # Take the center of the iris
            left_center = np.mean(left_iris_pts, axis=0).astype(int)
            right_center = np.mean(right_iris_pts, axis=0).astype(int)

            # Draw iris centers
            cv2.circle(frame, tuple(left_center), 3, (0, 255, 0), -1)
            cv2.circle(frame, tuple(right_center), 3, (0, 255, 0), -1)

            # Eye corner landmarks (outer and inner)
            left_eye_left = face_landmarks.landmark[33]   # left corner
            left_eye_right = face_landmarks.landmark[133] # right corner
            left_eye_top = face_landmarks.landmark[159]   # top eyelid
            left_eye_bottom = face_landmarks.landmark[145] # bottom eyelid

            # Convert to pixels
            left_eye_box = {
                "left": int(left_eye_left.x * w),
                "right": int(left_eye_right.x * w),
                "top": int(left_eye_top.y * h),
                "bottom": int(left_eye_bottom.y * h),
            }

            # Get direction
            cx, cy = left_center
            direction = "CENTER"
            if cx < left_eye_box["left"] + (left_eye_box["right"] - left_eye_box["left"]) * 0.35:
                direction = "LEFT"
            elif cx > left_eye_box["left"] + (left_eye_box["right"] - left_eye_box["left"]) * 0.65:
                direction = "RIGHT"
            elif cy < left_eye_box["top"]:
                direction = "UP"
            elif cy > left_eye_box["bottom"]:
                direction = "DOWN"

            # Show direction on frame
            cv2.putText(frame, f"Direction: {direction}", (30, 50),
                        cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)

            print("Eye Direction:", direction)  # you can replace this with API call

    cv2.imshow("Eye Tracking", frame)

    if cv2.waitKey(1) & 0xFF == 27:  # ESC to exit
        break

cap.release()
cv2.destroyAllWindows()
