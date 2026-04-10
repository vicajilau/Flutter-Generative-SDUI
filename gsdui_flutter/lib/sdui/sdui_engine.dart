import 'package:flutter/material.dart';

class SduiEngine {
  static Widget buildWidget(Map<String, dynamic>? schema) {
    if (schema == null) {
      return const SizedBox.shrink();
    }

    final type = schema['type'] as String?;
    if (type == null) {
      return const Text(
        'Error: Widget type is missing.',
        style: TextStyle(color: Colors.red),
      );
    }

    switch (type) {
      case 'Container':
        return _buildContainer(schema);
      case 'Column':
        return _buildFlex(schema, isColumn: true);
      case 'Row':
        return _buildFlex(schema, isColumn: false);
      case 'Text':
        return _buildText(schema);
      case 'Icon':
        return _buildIcon(schema);
      case 'ElevatedButton':
        return _buildElevatedButton(schema);
      default:
        return Text(
          'Unsupported widget type: $type',
          style: const TextStyle(color: Colors.red),
        );
    }
  }

  static Widget _buildContainer(Map<String, dynamic> schema) {
    Color? bgColor;
    if (schema['color'] != null) {
      bgColor = _parseColor(schema['color']);
    }

    double padding = 0;
    if (schema['padding'] != null) {
      padding = (schema['padding'] as num).toDouble();
    }

    final childSchema = schema['child'] as Map<String, dynamic>?;

    return Container(
      color: bgColor,
      padding: EdgeInsets.all(padding),
      child: buildWidget(childSchema),
    );
  }

  static Widget _buildFlex(
    Map<String, dynamic> schema, {
    required bool isColumn,
  }) {
    final mainAxisAlignmentStr = schema['mainAxisAlignment'] as String?;
    final crossAxisAlignmentStr = schema['crossAxisAlignment'] as String?;

    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
    switch (mainAxisAlignmentStr) {
      case 'center':
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case 'end':
        mainAxisAlignment = MainAxisAlignment.end;
        break;
      case 'spaceBetween':
        mainAxisAlignment = MainAxisAlignment.spaceBetween;
        break;
      case 'spaceAround':
        mainAxisAlignment = MainAxisAlignment.spaceAround;
        break;
      case 'spaceEvenly':
        mainAxisAlignment = MainAxisAlignment.spaceEvenly;
        break;
    }

    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;
    switch (crossAxisAlignmentStr) {
      case 'start':
        crossAxisAlignment = CrossAxisAlignment.start;
        break;
      case 'end':
        crossAxisAlignment = CrossAxisAlignment.end;
        break;
      case 'stretch':
        crossAxisAlignment = CrossAxisAlignment.stretch;
        break;
    }

    final childrenData = schema['children'] as List<dynamic>? ?? [];
    final children = childrenData
        .map((e) => buildWidget(e as Map<String, dynamic>?))
        .toList();

    if (isColumn) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }
  }

  static Widget _buildText(Map<String, dynamic> schema) {
    final text = schema['text'] as String? ?? '';
    final fontSize = (schema['fontSize'] as num?)?.toDouble() ?? 14.0;
    Color? color;
    if (schema['color'] != null) {
      color = _parseColor(schema['color']);
    }
    final fontWeightStr = schema['fontWeight'] as String?;
    FontWeight fontWeight = FontWeight.normal;
    if (fontWeightStr == 'bold') {
      fontWeight = FontWeight.bold;
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }

  static Widget _buildIcon(Map<String, dynamic> schema) {
    final iconName = schema['icon'] as String? ?? 'error';
    final size = (schema['size'] as num?)?.toDouble() ?? 24.0;
    Color? color;
    if (schema['color'] != null) {
      color = _parseColor(schema['color']);
    }

    // A very basic map of icons. In a real app we'd map many more.
    IconData iconData = Icons.error;
    switch (iconName) {
      case 'home':
        iconData = Icons.home;
        break;
      case 'person':
        iconData = Icons.person;
        break;
      case 'settings':
        iconData = Icons.settings;
        break;
      case 'star':
        iconData = Icons.star;
        break;
      case 'search':
        iconData = Icons.search;
        break;
      case 'check':
        iconData = Icons.check;
        break;
      case 'close':
        iconData = Icons.close;
        break;
      case 'favorite':
        iconData = Icons.favorite;
        break;
      case 'info':
        iconData = Icons.info;
        break;
    }

    return Icon(iconData, size: size, color: color);
  }

  static Widget _buildElevatedButton(Map<String, dynamic> schema) {
    final text = schema['text'] as String? ?? 'Button';

    return ElevatedButton(
      onPressed: () {
        debugPrint('Generated button pressed!');
      },
      child: Text(text),
    );
  }

  static Color _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return Colors.transparent;
    try {
      final hex = colorStr.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return Colors.transparent;
  }
}
