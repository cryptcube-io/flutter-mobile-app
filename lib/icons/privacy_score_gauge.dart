import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      width: 280, // Fixed width to control gauge size
      height: 140, // Half height for semi-circle
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 850,
            showLabels: false,
            showTicks: false,
            radiusFactor: 1,
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
            startAngle: 180,
            endAngle: 0,
            canRotateLabels: false,
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.value.toInt()}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                angle: 90,
                positionFactor: 0.1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}