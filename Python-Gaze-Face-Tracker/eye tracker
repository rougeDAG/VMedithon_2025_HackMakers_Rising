import cv2
import mediapipe as mp

# Initialize MediaPipe Face Mesh with iris refinement
mp_face_mesh = mp.solutions.face_mesh
face_mesh = mp_face_mesh.FaceMesh(refine_landmarks=True, max_num_faces=1)

# Iris landmark indices (from MediaPipe documentation)
LEFT_IRIS = [474, 475, 476, 477]
RIGHT_IRIS = [469, 470, 471, 472]

# Eye corner landmarks (for reference bounding box)
LEFT_EYE = [33, 133]
RIGHT_EYE = [362, 263]

# Start video capture
cap = cv2.VideoCapture(0)

while cap.isOpened():
    success, frame = cap.read()
    if not success:
        break

    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = face_mesh.process(frame_rgb)
    image_h, image_w = frame.shape[:2]

    if results.multi_face_landmarks:
        for face_landmarks in results.multi_face_landmarks:
            # Left iris center
            left_iris = []
            for idx in LEFT_IRIS:
                x = int(face_landmarks.landmark[idx].x * image_w)
                y = int(face_landmarks.landmark[idx].y * image_h)
                left_iris.append((x, y))
                cv2.circle(frame, (x, y), 2, (0, 255, 0), -1)

            # Right iris center
            right_iris = []
            for idx in RIGHT_IRIS:
                x = int(face_landmarks.landmark[idx].x * image_w)
                y = int(face_landmarks.landmark[idx].y * image_h)
                right_iris.append((x, y))
                cv2.circle(frame, (x, y), 2, (0, 255, 0), -1)

            # Approximate center of each iris
            if left_iris:
                lx = sum([p[0] for p in left_iris]) // len(left_iris)
                ly = sum([p[1] for p in left_iris]) // len(left_iris)
                cv2.circle(frame, (lx, ly), 3, (0, 0, 255), -1)
                cv2.putText(frame, f"Left Pupil: ({lx},{ly})", (30, 50),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 255), 2)

            if right_iris:
                rx = sum([p[0] for p in right_iris]) // len(right_iris)
                ry = sum([p[1] for p in right_iris]) // len(right_iris)
                cv2.circle(frame, (rx, ry), 3, (0, 0, 255), -1)
                cv2.putText(frame, f"Right Pupil: ({rx},{ry})", (30, 80),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 255), 2)

    cv2.imshow("Iris Tracking", frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
