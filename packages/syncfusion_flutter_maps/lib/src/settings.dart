import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'behavior/zoom_pan_behavior.dart';
import 'elements/marker.dart';
import 'enum.dart';

/// Signature used by the [MapShapeLayer.loadingBuilder].
typedef MapLoadingBuilder = Widget Function(BuildContext context);

/// Signature to return the string values from the data source
/// based on the index.
typedef IndexedStringValueMapper = String Function(int index);

/// Signature to return the double values from the data source
/// based on the index.
typedef IndexedDoubleValueMapper = double Function(int index);

/// Signature to return the colors or other types from the data source based on
/// the index based on which colors will be applied.
typedef IndexedColorValueMapper = dynamic Function(int index);

/// Signature to return the [MapMarker].
typedef MapMarkerBuilder = MapMarker Function(BuildContext context, int index);

/// Signature for a [MapLayer.onWillZoom] callback which returns true or false
/// based on which current zooming completes.
typedef WillZoomCallback = bool Function(MapZoomDetails);

/// Signature for a [MapLayer.onWillPan]  callback which returns true or false
/// based on which current panning completes.
typedef WillPanCallback = bool Function(MapPanDetails);

/// Customizes the shape or bubble color based on the data source and sets the
/// text and icon color for legend items.
///
/// [MapShapeSource.shapeColorMappers] and
/// [MapShapeSource.bubbleColorMappers] accepts collection of
/// [MapColorMapper].
///
/// [MapShapeSource.shapeColorValueMapper] and
/// [MapShapeSource.bubbleColorValueMapper] returns a color or value
/// based on which shape or bubble color will be updated.
///
/// If they return a color, then this color will be applied to the shapes or
/// bubbles straightaway.
///
/// If they return a value other than the color, then you must set the
/// [MapShapeSource.shapeColorMappers] or
/// [MapShapeSource.bubbleColorMappers] property.
///
/// The value returned from the [MapShapeSource.shapeColorValueMapper]
/// and [MapShapeSource.bubbleColorValueMapper] will be used for the
/// comparison in the [MapColorMapper.value] or [MapColorMapper.from] and
/// [MapColorMapper.to]. Then, the [MapColorMapper.color] will be applied to
/// the respective shape or bubble.
///
/// Legend icon's color and text will be taken from [MapColorMapper.color] or
/// [MapColorMapper.text] respectively.
///
/// The below code snippet represents how color can be applied to the shape
/// based on the [MapColorMapper.value] property of [MapColorMapper].
///
/// ```dart
/// List<Model> data;
///
///  @override
///  void initState() {
///    super.initState();
///
///    data = <Model>[
///     Model('India', 280, "Low"),
///     Model('United States of America', 190, "High"),
///     Model('Pakistan', 37, "Low"),
///    ];
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          source: MapShapeSource.asset(
///              "assets/world_map.json",
///              shapeDataField: "name",
///              dataCount: data.length,
///              primaryValueMapper: (index) {
///                return data[index].country;
///              },
///              shapeColorValueMapper: (index) {
///                return data[index].storage;
///              },
///              shapeColorMappers: [
///                MapColorMapper(value: "Low", color: Colors.red),
///                MapColorMapper(value: "High", color: Colors.green)
///              ]),
///        )
///      ],
///    );
///  }
/// ```
/// The below code snippet represents how color can be applied to the shape
/// based on the range between [MapColorMapper.from] and [MapColorMapper.to]
/// properties of [MapColorMapper].
///
/// ```dart
/// List<Model> data;
///
///  @override
///  void initState() {
///    super.initState();
///
///    data = <Model>[
///     Model('India', 100, "Low"),
///     Model('United States of America', 200, "High"),
///     Model('Pakistan', 75, "Low"),
///    ];
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          source: MapShapeSource.asset(
///              "assets/world_map.json",
///              shapeDataField: "name",
///              dataCount: data.length,
///              primaryValueMapper: (index) {
///                return data[index].country;
///              },
///              shapeColorValueMapper: (index) {
///                return data[index].count;
///              },
///              shapeColorMappers: [
///                MapColorMapper(from: 0, to:  100, color: Colors.red),
///                MapColorMapper(from: 101, to: 200, color: Colors.yellow)
///             ]),
///        )
///      ],
///    );
///  }
/// ```
///
/// See also:
/// * [MapShapeSource.shapeColorValueMapper] and
/// [MapShapeSource.shapeColorMappers], to customize the shape colors
/// based on the data.
/// * [MapShapeSource.bubbleColorValueMapper] and
/// [MapShapeSource.bubbleColorMappers], to customize the shape colors
/// based on the data.
class MapColorMapper {
  /// Creates a [MapColorMapper].
  const MapColorMapper({
    this.from,
    this.to,
    this.value,
    this.color,
    this.minOpacity,
    this.maxOpacity,
    this.text,
  })  : assert((from == null && to == null) ||
            (from != null && to != null && from < to && to > from)),
        assert(minOpacity == null || minOpacity != 0),
        assert(maxOpacity == null || maxOpacity != 0);

  /// Sets the range start for the color mapping.
  ///
  /// The shape or bubble will render in the specified [color] if the value
  /// returned in the [MapShapeSource.shapeColorValueMapper] or
  /// [MapShapeSource.bubbleColorValueMapper] falls between the [from]
  /// and [to] range.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].count;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(from: 0, to:  100, color: Colors.red),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.yellow)
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [to], to set the range end for the range color mapping.
  /// * [value], to set the value for the equal color mapping.
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors
  /// based on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final double from;

  /// Sets the range end for the color mapping.
  ///
  /// The shape or bubble will render in the specified [color] if the value
  /// returned in the [MapShapeSource.shapeColorValueMapper] or
  /// [MapShapeSource.bubbleColorValueMapper] falls between the [from]
  /// and [to] range.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].count;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(from: 0, to:  100, color: Colors.red),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.yellow)
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [from], to set the range start for the range color mapping.
  /// * [value], to set the value for the equal color mapping.
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors based
  /// on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final double to;

  /// Sets the value for the equal color mapping.
  ///
  /// The shape or bubble will render in the specified [color] if the value
  /// returned in the [MapShapeSource.shapeColorValueMapper] or
  /// [MapShapeSource.bubbleColorValueMapper] is equal to this [value].
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].storage;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(value: "Low", color: Colors.red),
  ///                MapColorMapper(value: "High", color: Colors.green)
  ///              ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [color], to set the color for the shape or bubble.
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors
  /// based on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final String value;

  /// Specifies the color applies to the shape or bubble based on the value.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].storage;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(value: "Low", color: Colors.red),
  ///                MapColorMapper(value: "High", color: Colors.green)
  ///              ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [from], to set the range start for the range color mapping.
  /// * [to], to set the range end for the range color mapping.
  /// * [value], to set the value for the equal color mapping.
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors
  /// based on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final Color color;

  /// Specifies the minimum opacity applies to the shape or bubble while using
  /// [from] and [to].
  ///
  /// The shapes or bubbles with lowest value which is [from] will be applied a
  /// [minOpacity] and the shapes or bubbles with highest value which is [to]
  /// will be applied a [maxOpacity]. The shapes or bubbles with values in-
  /// between the range will get a opacity based on their respective value.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].count;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(from: 0, to:  100, color: Colors.yellow,
  ///                maxOpacity: 0.2, minOpacity: 0.5),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.red,
  ///                maxOpacity: 0.6, minOpacity: 1)
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors
  /// based on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final double minOpacity;

  /// Specifies the maximum opacity applies to the shape or bubble while using
  /// [from] and [to].
  ///
  /// The shapes or bubbles with lowest value which is [from] will be applied a
  /// [minOpacity] and the shapes or bubbles with highest value which is [to]
  /// will be applied a [maxOpacity]. The shapes or bubbles with values in-
  /// between the range will get a opacity based on their respective value.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].count;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(from: 0, to:  100, color: Colors.yellow,
  ///                maxOpacity: 0.2, minOpacity: 0.5),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.red,
  ///                maxOpacity: 0.6, minOpacity: 1)
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors based
  /// on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final double maxOpacity;

  /// Specifies the text to be used for the legend item.
  ///
  /// By default, [MapColorMapper.from] and [MapColorMapper.to] or
  /// [MapColorMapper.value] will be used as the text of the legend item.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].count;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(from: 0, to:  100, color: Colors.yellow,
  ///                maxOpacity: 0.2, minOpacity: 0.5, text: "low"),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.red,
  ///                maxOpacity: 0.6, minOpacity: 1, text: "high")
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [MapShapeSource.shapeColorMappers], to set the shape colors based
  /// on the specific value.
  /// * [MapShapeSource.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.

  final String text;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapColorMapper &&
        other.from == from &&
        other.to == to &&
        other.value == value &&
        other.color == color &&
        other.minOpacity == minOpacity &&
        other.maxOpacity == maxOpacity &&
        other.text == text;
  }

  @override
  int get hashCode =>
      hashValues(from, to, value, color, minOpacity, maxOpacity, text);
}

/// Customizes the appearance of the data labels.
///
/// It is possible to customize the style of the data labels, hide or trim the
/// data labels when it exceeds their respective shapes.
///
/// ```dart
///  @override
///  Widget build(BuildContext context) {
///    return
///      SfMaps(
///        layers: [
///          MapShapeLayer(
///            dataLabelSettings:
///                MapDataLabelSettings(
///                    textStyle: TextStyle(color: Colors.red)
///                ),
///            source: MapShapeSource.asset(
///                showDataLabels: true,
///                "assets/world_map.json",
///                shapeDataField: "continent",
///                dataCount: bubbleData.length,
///                primaryValueMapper: (index) {
///                  return bubbleData[index].country;
///                }),
///          )
///        ],
///    );
///  }
/// ```
@immutable
class MapDataLabelSettings extends DiagnosticableTree {
  /// Creates a [MapDataLabelSettings].
  const MapDataLabelSettings({
    this.textStyle,
    this.overflowMode = MapLabelOverflow.visible,
  });

  /// Customizes the data label's text style.
  ///
  /// This snippet shows how to set [textStyle] for the data labels in [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            dataLabelSettings:
  ///                MapDataLabelSettings(
  ///                    textStyle: TextStyle(color: Colors.red)
  ///                ),
  ///            source: MapShapeSource.asset(
  ///                showDataLabels: true,
  ///                "assets/world_map.json",
  ///                shapeDataField: "continent",
  ///                dataCount: bubbleData.length,
  ///                primaryValueMapper: (index) {
  ///                  return bubbleData[index].country;
  ///                }),
  ///          )
  ///        ],
  ///    );
  ///  }
  /// ```
  final TextStyle textStyle;

  /// Trims or removes the data label when it is overflowed from the shape.
  ///
  /// Defaults to [MapLabelOverflow.visible].
  ///
  /// By default, the data labels will render even if it overflows form the
  /// shape. Using this property, it is possible to remove or trim the data
  /// labels based on the available space in the shape.
  ///
  /// This snippet shows how to set the [overflowMode] for the data labels in
  /// [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            dataLabelSettings:
  ///                MapDataLabelSettings(
  ///                    overflowMode: MapLabelOverflow.hide
  ///                ),
  ///            source: MapShapeSource.asset(
  ///                showDataLabels: true,
  ///                "assets/world_map.json",
  ///                shapeDataField: "continent",
  ///                dataCount: bubbleData.length,
  ///                primaryValueMapper: (index) {
  ///                  return bubbleData[index].country;
  ///                }),
  ///          )
  ///        ],
  ///    );
  ///  }
  /// ```
  final MapLabelOverflow overflowMode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapDataLabelSettings &&
        other.textStyle == textStyle &&
        other.overflowMode == overflowMode;
  }

  @override
  int get hashCode => hashValues(textStyle, overflowMode);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    if (textStyle != null) {
      properties.add(textStyle.toDiagnosticsNode(name: 'textStyle'));
    }
    properties
        .add(EnumProperty<MapLabelOverflow>('overflowMode', overflowMode));
  }
}

/// Customizes the appearance of the bubbles.
///
/// It is possible to customize the radius, color, opacity and stroke of the
/// bubbles.
///
/// ```dart
///  @override
///  Widget build(BuildContext context) {
///    return
///      SfMaps(
///        layers: [
///          MapShapeLayer(
///            bubbleSettings: MapBubbleSettings(maxRadius: 10, minRadius: 2),
///            source: MapShapeSource.asset(
///                "assets/world_map.json",
///                shapeDataField: "name",
///                dataCount: bubbleData.length,
///                primaryValueMapper: (index) {
///                  return bubbleData[index].country;
///                },
///                bubbleSizeMapper: (index) {
///                  return bubbleData[index].usersCount;
///                }),
///        )
///      ],
///    );
///  }
/// ```
@immutable
class MapBubbleSettings extends DiagnosticableTree {
  /// Creates a [MapBubbleSettings].
  const MapBubbleSettings({
    this.minRadius = 10.0,
    this.maxRadius = 50.0,
    this.color,
    this.strokeWidth,
    this.strokeColor,
  });

  /// Minimum radius of the bubble.
  ///
  /// The radius of the bubble depends on the value returned in the
  /// [MapShapeSource.bubbleSizeMapper]. From all the returned values,
  /// the lowest value will have [minRadius] and the highest value will have
  /// [maxRadius].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            bubbleSettings: MapBubbleSettings(maxRadius: 10, minRadius: 2),
  ///            source: MapShapeSource.asset(
  ///                "assets/world_map.json",
  ///                shapeDataField: "name",
  ///                dataCount: bubbleData.length,
  ///                primaryValueMapper: (index) {
  ///                  return bubbleData[index].country;
  ///                },
  ///                bubbleSizeMapper: (index) {
  ///                  return bubbleData[index].usersCount;
  ///                }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final double minRadius;

  /// Maximum radius of the bubble.
  ///
  /// The radius of the bubble depends on the value returned in the
  /// [MapShapeSource.bubbleSizeMapper]. From all the returned values,
  /// the lowest value will have [minRadius] and the highest value will have
  /// [maxRadius].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            bubbleSettings: MapBubbleSettings(maxRadius: 10, minRadius: 2),
  ///            source: MapShapeSource.asset(
  ///                "assets/world_map.json",
  ///                shapeDataField: "name",
  ///                dataCount: bubbleData.length,
  ///                primaryValueMapper: (index) {
  ///                  return bubbleData[index].country;
  ///                },
  ///                bubbleSizeMapper: (index) {
  ///                  return bubbleData[index].usersCount;
  ///                }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final double maxRadius;

  /// Default color of the bubbles.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///          bubbleSettings: MapBubbleSettings(
  ///              color: Colors.black),
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                 return bubbleData[index].usersCount;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [MapShapeSource.bubbleColorMappers] and
  /// [MapShapeSource.bubbleColorValueMapper], to customize the bubble
  /// colors based on the data.
  final Color color;

  /// Stroke width of the bubbles.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///          bubbleSettings: MapBubbleSettings(
  ///              strokeColor: Colors.red,
  ///              strokeWidth: 2),
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                 return bubbleData[index].usersCount;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [strokeColor], to set the stroke color.
  final double strokeWidth;

  /// Stroke color of the bubbles.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///          bubbleSettings: MapBubbleSettings(
  ///              strokeColor: Colors.red,
  ///              strokeWidth: 2),
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                 return bubbleData[index].usersCount;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [strokeWidth], to set the stroke width.
  final Color strokeColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapBubbleSettings &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.strokeColor == strokeColor &&
        other.minRadius == minRadius &&
        other.maxRadius == maxRadius;
  }

  @override
  int get hashCode =>
      hashValues(color, strokeWidth, strokeColor, maxRadius, minRadius);

  /// Creates a copy of this class but with the given fields
  /// replaced with the new values.
  MapBubbleSettings copyWith({
    double minRadius,
    double maxRadius,
    Color color,
    double strokeWidth,
    Color strokeColor,
  }) {
    return MapBubbleSettings(
      minRadius: minRadius ?? this.minRadius,
      maxRadius: maxRadius ?? this.maxRadius,
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeColor: strokeColor ?? this.strokeColor,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (strokeWidth != null) {
      properties.add(DoubleProperty('strokeWidth', strokeWidth));
    }

    if (strokeColor != null) {
      properties.add(ColorProperty('strokeColor', strokeColor));
    }

    properties.add(DoubleProperty('minRadius', minRadius));
    properties.add(DoubleProperty('maxRadius', maxRadius));
  }
}

/// Customizes the appearance of the selected shape.
///
/// ```dart
///  int _selectedIndex = -1;
///
///  @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          selectedIndex: _selectedIndex,
///          onSelectionChanged: (int index) {
///             setState(() {
///                // Passing -1 to the unselect the previously selected shape.
///                _selectedIndex = (_selectedIndex == index) ? -1 : index;
///             });
///          },
///          selectionSettings: MapSelectionSettings(
///              color: Colors.black
///          ),
///          source: MapShapeSource.asset(
///              "assets/world_map.json",
///              shapeDataField: "name",
///              dataCount: bubbleData.length,
///              primaryValueMapper: (index) {
///                return bubbleData[index].country;
///              }),
///        )
///      ],
///    );
///  }
/// ```
@immutable
class MapSelectionSettings extends DiagnosticableTree {
  /// Creates a [MapSelectionSettings].
  const MapSelectionSettings({this.color, this.strokeColor, this.strokeWidth});

  /// Fills the selected shape by this color.
  ///
  /// This snippet shows how to set selection color in [SfMaps].
  ///
  /// ```dart
  ///  int _selectedIndex = -1;
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          selectedIndex: _selectedIndex,
  ///          onSelectionChanged: (int index) {
  ///             setState(() {
  ///                // Passing -1 to the unselect the previously selected shape.
  ///                _selectedIndex = (_selectedIndex == index) ? -1 : index;
  ///             });
  ///          },
  ///          selectionSettings: MapSelectionSettings(
  ///              color: Colors.black
  ///          ),
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// See also:
  /// * [strokeColor], to set stroke color for selected shape.
  final Color color;

  /// Applies stroke color for the selected shape.
  ///
  /// This snippet shows how to set stroke color for the selected shape.
  ///
  /// ```dart
  ///  int _selectedIndex = -1;
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          selectedIndex: _selectedIndex,
  ///          onSelectionChanged: (int index) {
  ///             setState(() {
  ///                // Passing -1 to the unselect the previously selected shape.
  ///                _selectedIndex = (_selectedIndex == index) ? -1 : index;
  ///             });
  ///          },
  ///          selectionSettings: MapSelectionSettings(
  ///              strokeColor: Colors.white
  ///          ),
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// See also:
  /// * [Color], to set selected shape color.
  final Color strokeColor;

  /// Stroke width which applies to the selected shape.
  ///
  /// This snippet shows how to set stroke width for the selected shape.
  ///
  /// ```dart
  ///  int _selectedIndex = -1;
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          selectedIndex: _selectedIndex,
  ///          onSelectionChanged: (int index) {
  ///             setState(() {
  ///                // Passing -1 to the unselect the previously selected shape.
  ///                _selectedIndex = (_selectedIndex == index) ? -1 : index;
  ///             });
  ///          },
  ///          selectionSettings: MapSelectionSettings(
  ///              strokeWidth: 2
  ///          ),
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final double strokeWidth;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MapSelectionSettings &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.strokeColor == strokeColor;
  }

  @override
  int get hashCode => hashValues(color, strokeWidth, strokeColor);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (strokeWidth != null) {
      properties.add(DoubleProperty('strokeWidth', strokeWidth));
    }

    if (strokeColor != null) {
      properties.add(ColorProperty('strokeColor', strokeColor));
    }
  }
}

/// Customizes the appearance of the bubble's or shape's tooltip.
///
/// ```dart
///  @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          tooltipSettings: MapTooltipSettings(
///              color: Colors.black
///          ),
///          source: MapShapeSource.asset(
///              "assets/world_map.json",
///              shapeDataField: "continent",
///              dataCount: bubbleData.length,
///              primaryValueMapper: (index) {
///                return bubbleData[index].country;
///              }),
///        )
///      ],
///    );
///  }
/// ```
///
/// See also:
/// * [MapShapeLayer.shapeTooltipBuilder], for showing the completely
/// customized widget inside the tooltip.
@immutable
class MapTooltipSettings extends DiagnosticableTree {
  /// Creates a [MapTooltipSettings].
  const MapTooltipSettings({
    this.color,
    this.strokeWidth,
    this.strokeColor,
  });

  /// Fills the tooltip by this color.
  ///
  /// This snippet shows how to set the tooltip color in [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          tooltipSettings: MapTooltipSettings(
  ///              color: Colors.black
  ///          ),
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// See also:
  /// * [textStyle], for customizing the style of the tooltip text.
  final Color color;

  /// Specifies the stroke width applies to the tooltip.
  ///
  /// This snippet shows how to customize the stroke width in [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          tooltipSettings: MapTooltipSettings(
  ///              strokeWidth: 2
  ///          ),
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// See also:
  /// * [strokeColor], for customizing the stroke color of the tooltip.
  final double strokeWidth;

  /// Specifies the stroke color applies to the tooltip.
  ///
  /// This snippet shows how to customize stroke color in [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          tooltipSettings: MapTooltipSettings(
  ///              strokeColor: Colors.white
  ///          ),
  ///          source: MapShapeSource.asset(
  ///              "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [strokeWidth] for customizing the stroke width of the tooltip.
  final Color strokeColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MapTooltipSettings &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.strokeColor == strokeColor;
  }

  @override
  int get hashCode => hashValues(color, strokeWidth, strokeColor);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    if (color != null) {
      properties.add(ColorProperty('color', color));
    }

    if (strokeWidth != null) {
      properties.add(DoubleProperty('strokeWidth', strokeWidth));
    }

    if (strokeColor != null) {
      properties.add(ColorProperty('strokeColor', strokeColor));
    }
  }
}

/// Provides options for customizing the appearance of the toolbar in the web
/// platform.
class MapToolbarSettings extends DiagnosticableTree {
  /// Creates a [MapToolbarSettings].
  const MapToolbarSettings({
    this.iconColor,
    this.itemBackgroundColor,
    this.itemHoverColor,
    this.direction = Axis.horizontal,
    this.position = MapToolbarPosition.topRight,
  });

  /// Specifies the color applies to the tooltip icons.
  final Color iconColor;

  /// Specifies the color applies to the tooltip icon's background.
  final Color itemBackgroundColor;

  /// Specifies the color applies to the tooltip icon's background on hovering.
  final Color itemHoverColor;

  /// Arranges the toolbar items in either horizontal or vertical direction.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis direction;

  /// Option to position the toolbar in all the corners of the maps.
  ///
  /// Defaults to [MapToolbarPosition.topRight].
  final MapToolbarPosition position;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    if (iconColor != null) {
      properties.add(ColorProperty('iconColor', iconColor));
    }
    if (itemBackgroundColor != null) {
      properties.add(ColorProperty('itemBackgroundColor', itemBackgroundColor));
    }

    if (itemHoverColor != null) {
      properties.add(ColorProperty('itemHoverColor', itemHoverColor));
    }
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(EnumProperty<MapToolbarPosition>('position', position));
  }
}