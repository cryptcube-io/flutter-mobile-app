import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SimpleRadialGauge extends StatefulWidget {
  final double value;

  SimpleRadialGauge({
    required this.value,
  });

  @override
  _SimpleRadialGaugeState createState() => _SimpleRadialGaugeState();
}

class _SimpleRadialGaugeState extends State<SimpleRadialGauge> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 115, // Ensure height is proportional to the arc
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: SizedBox(
          width: 90, // Container width
          height: 50, // Container height
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 850,
                showLabels: false,
                showTicks: false,
                radiusFactor: 0.9, // Adjust radiusFactor to fit the box edges
                axisLineStyle: AxisLineStyle(
                  thickness: 0.1,
                  color: Colors.grey.withOpacity(0.1),
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: widget.value,
                    width: 0.1,
                    sizeUnit: GaugeSizeUnit.factor,
                    enableAnimation: true,
                    animationDuration: 1000,
                    color: const Color(0xFF6C5CE7),
                  ),
                ],
                startAngle: 180, // Start at the left edge
                endAngle: 0, // End at the right edge
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.value.toInt()}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    angle: 90,
                    positionFactor: 0.0, // Adjust annotation position if needed
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
