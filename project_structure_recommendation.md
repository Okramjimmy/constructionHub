Use a feature-first folder structure:
lib/
├── core/
│   ├── theme/         # colors, typography, spacing tokens
│   ├── widgets/       # shared UI components
│   └── utils/
├── features/
│   ├── auth/          # login page
│   ├── home/          # command hub
│   ├── projects/      # project list + sub-types
│   ├── checklist/     # inspection form
│   ├── ai_processing/ # AI upload + results
│   └── annotation/    # image annotation canvas
└── main.dart
Tech stack suggestions

State management — Riverpod or BLoC (BLoC fits enterprise scale better)
Navigation — go_router for deep linking between pages
Image annotation — painter package or raw CustomPainter on a GestureDetector
Camera/gallery — image_picker
AI backend — REST calls to your FastAPI/Flask ML endpoint via dio
Local storage — flutter_secure_storage for auth tokens, hive for offline checklist drafts
Maps thumbnail — flutter_map (OpenStreetMap, free) or Google Maps SDK

Theme tokens from the design
dartclass AppColors {
  static const navy     = Color(0xFF0A192F);
  static const orange   = Color(0xFFFF6B00);
  static const slate    = Color(0xFF8B9DB5);
  static const light    = Color(0xFFF4F6F9);
  static const green    = Color(0xFF1A9E5C);
  static const yellow   = Color(0xFFD4A017);
  static const red      = Color(0xFFC0392B);
  static const border   = Color(0xFFDCE3ED);
}
Key Flutter-specific tips for this UI
The annotation canvas (Page 7) is the most complex — use CustomPainter with a GestureDetector wrapping an InteractiveViewer so users can pinch-zoom and draw bounding boxes simultaneously.
For the pass/fail toggles on the checklist, a simple StatefulWidget with two GestureDetector-wrapped containers will be cleaner than using ToggleButtons.
The sticky "Submit & Timestamp Log" button should use a Stack with a Positioned widget at the bottom, or wrap the ListView in a Column with the button outside the scroll area.