import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/checklist_item_model.dart';
import '../providers/checklist_provider.dart';
import '../../../core/theme/app_colors.dart';

class ChecklistItemCard extends ConsumerStatefulWidget {
  const ChecklistItemCard({
    super.key,
    required this.formTypeId,
    required this.item,
  });

  final String formTypeId;
  final ChecklistItemModel item;

  @override
  ConsumerState<ChecklistItemCard> createState() => _ChecklistItemCardState();
}

class _ChecklistItemCardState extends ConsumerState<ChecklistItemCard> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.item.value != null ? widget.item.value.toString() : '',
    );
  }

  @override
  void didUpdateWidget(covariant ChecklistItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.value != oldWidget.item.value) {
      final newText = widget.item.value != null ? widget.item.value.toString() : '';
      if (_textController.text != newText) {
        _textController.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(checklistProvider(widget.formTypeId).notifier);
    final isDone = widget.item.isCompleted;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: number + name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.item.number.toString().padLeft(2, '0'),
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      style: GoogleFonts.sora(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    if (widget.item.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.item.description!,
                        style: GoogleFonts.sora(
                          fontSize: 11,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Fieldtype Badge Icon
              _buildFieldBadge(),
              const SizedBox(width: 6),
              // Completed Checkmark
              if (isDone)
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Render field input based on field type
          _buildFieldInput(context, notifier),

          // Audit photo and remarks
          const SizedBox(height: 14),
          _buildUtilitySection(notifier),
        ],
      ),
    );
  }

  Widget _buildFieldBadge() {
    final (icon, name) = _getFieldMeta(widget.item.fieldType);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 4),
          Text(
            name,
            style: GoogleFonts.ibmPlexMono(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  (String, String) _getFieldMeta(String type) {
    return switch (type.toLowerCase()) {
      'int' => ('🔢', 'INT'),
      'float' => ('🔣', 'FLOAT'),
      'currency' => ('💰', 'CURRENCY'),
      'percent' => ('％', 'PERCENT'),
      'check' => ('☑', 'CHECK'),
      'date' => ('📅', 'DATE'),
      'datetime' => ('📅', 'DATETIME'),
      'time' => ('⏱', 'TIME'),
      'duration' => ('⏳', 'DURATION'),
      'rating' => ('⭐', 'RATING'),
      'color' => ('🎨', 'COLOR'),
      'signature' => ('✒', 'SIGNATURE'),
      'geolocation' => ('📍', 'GPS'),
      'attach' => ('📎', 'ATTACH'),
      'attach image' => ('🖼', 'IMAGE'),
      'select' => ('▾', 'SELECT'),
      'autocomplete' => ('🔍', 'SEARCH'),
      _ => ('📝', 'TEXT'),
    };
  }

  Widget _buildFieldInput(BuildContext context, ChecklistNotifier notifier) {
    final type = widget.item.fieldType.toLowerCase();
    final value = widget.item.value;

    // Checkbox / Boolean
    if (type == 'check') {
      final checked = value is bool ? value : false;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              checked ? 'Verified & Approved' : 'Requires Approval',
              style: GoogleFonts.sora(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: checked ? AppColors.green : AppColors.muted,
              ),
            ),
            Switch(
              value: checked,
              activeThumbColor: AppColors.green,
              activeTrackColor: AppColors.tagGreenBg,
              onChanged: (val) => notifier.setResult(widget.item.id, val),
            ),
          ],
        ),
      );
    }

    // Select / Autocomplete Dropdowns
    if (type == 'select' || type == 'autocomplete') {
      final options = widget.item.options;
      if (options.isEmpty) {
        return _buildPassFailSelector(notifier);
      }

      // If options <= 3, show them as horizontal chips/buttons
      if (options.length <= 3) {
        return Row(
          children: options.map((opt) {
            final isSelected = value?.toString() == opt;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _OptionChip(
                  label: opt,
                  isSelected: isSelected,
                  onTap: () => notifier.setResult(widget.item.id, opt),
                ),
              ),
            );
          }).toList(),
        );
      }

      // If > 3 options, render a dynamic Dropdown Menu
      return Container(
        decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: options.contains(value?.toString()) ? value.toString() : null,
            hint: Text(
              'Select an option...',
              style: GoogleFonts.sora(fontSize: 13, color: AppColors.muted),
            ),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.navy),
            items: options.map((opt) {
              return DropdownMenuItem(
                value: opt,
                child: Text(
                  opt,
                  style: GoogleFonts.sora(fontSize: 13, color: AppColors.text),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) notifier.setResult(widget.item.id, val);
            },
          ),
        ),
      );
    }

    // Rating (Stars)
    if (type == 'rating') {
      final rating = value is double ? value : (value is int ? value.toDouble() : 0.0);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final starPos = index + 1;
          final filled = rating >= starPos;
          return GestureDetector(
            onTap: () => notifier.setResult(widget.item.id, starPos.toDouble()),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                filled ? Icons.star_rounded : Icons.star_border_rounded,
                color: filled ? const Color(0xFFFFB020) : AppColors.slate,
                size: 32,
              ),
            ),
          );
        }),
      );
    }

    // Color Palette Selector
    if (type == 'color') {
      final colors = ['#E53935', '#1E88E5', '#43A047', '#FFB300', '#8E24AA', '#37474F'];
      final selectedColor = value?.toString() ?? '';
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: colors.map((colStr) {
          final hexColor = Color(int.parse(colStr.replaceFirst('#', '0xFF')));
          final isSelected = selectedColor == colStr;
          return GestureDetector(
            onTap: () => notifier.setResult(widget.item.id, colStr),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: hexColor,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: AppColors.navy, width: 3)
                    : Border.all(color: Colors.white, width: 1.5),
                boxShadow: isSelected
                    ? [BoxShadow(color: AppColors.navy.withValues(alpha: 0.3), blurRadius: 6)]
                    : [],
              ),
            ),
          );
        }).toList(),
      );
    }

    // Pickers: Date / Datetime / Time / Duration
    if (type == 'date' || type == 'datetime' || type == 'time' || type == 'duration') {
      final isDate = type == 'date';
      final isTime = type == 'time';
      final displayText = value?.toString() ?? 'Choose ${type.toUpperCase()}...';
      return GestureDetector(
        onTap: () async {
          if (isDate || type == 'datetime') {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              final formatted = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
              notifier.setResult(widget.item.id, formatted);
            }
          } else if (isTime) {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) {
              if (context.mounted) {
                notifier.setResult(widget.item.id, picked.format(context));
              }
            }
          } else {
            // Duration fallback
            notifier.setResult(widget.item.id, '02:30:00');
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.light,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayText,
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: value != null ? AppColors.text : AppColors.muted,
                ),
              ),
              Icon(
                isDate ? Icons.calendar_today_outlined : Icons.access_time_outlined,
                color: AppColors.navy,
                size: 16,
              ),
            ],
          ),
        ),
      );
    }

    // Geolocation Tagging (GPS)
    if (type == 'geolocation') {
      final isTagged = value != null;
      return GestureDetector(
        onTap: () {
          // Fetch Mock GPS coordinates
          notifier.setResult(
            widget.item.id,
            'Lat: 13.0827° N, Long: 80.2707° E · Accuracy 5m',
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: isTagged ? AppColors.tagGreenBg : AppColors.light,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isTagged ? AppColors.green : AppColors.border),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: isTagged ? AppColors.green : AppColors.slate,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isTagged ? value.toString() : '📍 TAG GPS COORDINATES',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sora(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isTagged ? AppColors.green : AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Digital Signature Canvas Drawing Pad
    if (type == 'signature') {
      final isSigned = value != null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SignatureCanvas(
            onSignatureChanged: (points) {
              if (points.isNotEmpty) {
                notifier.setResult(widget.item.id, 'Signed: ${points.length} coordinates');
              }
            },
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSigned ? '✒️ SIGNATURE SAVED' : 'Draw signature in the canvas above',
                style: GoogleFonts.sora(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSigned ? AppColors.green : AppColors.muted,
                ),
              ),
              GestureDetector(
                onTap: () {
                  notifier.setResult(widget.item.id, null);
                },
                child: Text(
                  'CLEAR',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Numeric Fields: Int, Float, Currency, Percent
    final isNumeric = ['int', 'float', 'currency', 'percent'].contains(type);
    final prefix = type == 'currency' ? '💰 \$' : '';
    final suffix = type == 'percent' ? ' ％' : '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          if (prefix.isNotEmpty) ...[
            Text(
              prefix,
              style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy),
            ),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: TextField(
              controller: _textController,
              keyboardType: isNumeric
                  ? const TextInputType.numberWithOptions(decimal: true, signed: true)
                  : TextInputType.text,
              maxLines: type == 'long text' ? 4 : 1,
              style: GoogleFonts.sora(fontSize: 13, color: AppColors.text),
              onChanged: (val) => notifier.setResult(widget.item.id, val),
              decoration: InputDecoration(
                hintText: isNumeric ? 'Enter value...' : 'Type feedback here...',
                hintStyle: GoogleFonts.sora(fontSize: 13, color: AppColors.muted),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (suffix.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              suffix,
              style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPassFailSelector(ChecklistNotifier notifier) {
    final value = widget.item.value;
    final isPass = value == 'PASS';
    final isFail = value == 'FAIL';

    return Row(
      children: [
        Expanded(
          child: _PassFailButton(
            label: '✓ PASS',
            isSelected: isPass,
            isPassing: true,
            onTap: () => notifier.setResult(widget.item.id, 'PASS'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _PassFailButton(
            label: '✗ FAIL',
            isSelected: isFail,
            isPassing: false,
            onTap: () => notifier.setResult(widget.item.id, 'FAIL'),
          ),
        ),
      ],
    );
  }

  Widget _buildUtilitySection(ChecklistNotifier notifier) {
    final hasPhoto = widget.item.photoPath != null;
    return Column(
      children: [
        // Camera upload
        GestureDetector(
          onTap: () => notifier.capturePhoto(widget.item.id),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: hasPhoto ? AppColors.green : AppColors.border,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  hasPhoto ? Icons.check_circle_outline : Icons.camera_alt_outlined,
                  color: hasPhoto ? AppColors.green : AppColors.slate,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  hasPhoto ? 'Photo Uploaded Successfully' : 'Add Inspection Photo',
                  style: GoogleFonts.sora(
                    fontSize: 12,
                    color: hasPhoto ? AppColors.green : AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PassFailButton extends StatelessWidget {
  const _PassFailButton({
    required this.label,
    required this.isSelected,
    required this.isPassing,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isPassing;
  final VoidCallback onTap;

  Color get _baseColor => isPassing ? AppColors.green : AppColors.red;
  Color get _bgColor => isPassing
      ? (isSelected ? AppColors.green : AppColors.tagGreenBg)
      : (isSelected ? AppColors.red : AppColors.tagRedBg);
  Color get _fgColor => isSelected ? Colors.white : (isPassing ? AppColors.green : AppColors.red);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _baseColor, width: 2),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.sora(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _fgColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : AppColors.light,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.navy : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.sora(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.navy,
            ),
          ),
        ),
      ),
    );
  }
}

// ── CUSTOM CANVAS SIGNATURE DRAWING PAD ───────────────────────────────────────

class SignatureCanvas extends StatefulWidget {
  final ValueChanged<List<Offset>> onSignatureChanged;
  const SignatureCanvas({super.key, required this.onSignatureChanged});

  @override
  State<SignatureCanvas> createState() => _SignatureCanvasState();
}

class _SignatureCanvasState extends State<SignatureCanvas> {
  final List<Offset> _points = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: GestureDetector(
        onPanUpdate: (details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          setState(() {
            _points.add(localPosition);
          });
          widget.onSignatureChanged(_points);
        },
        onPanEnd: (details) {
          setState(() {
            _points.add(Offset.infinite);
          });
          widget.onSignatureChanged(_points);
        },
        child: CustomPaint(
          painter: _SignaturePainter(points: _points),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset> points;
  _SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.navy
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.infinite && points[i + 1] != Offset.infinite) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) => true;
}
