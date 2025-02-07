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
      height: 115,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: SizedBox(
          width: 90,
          height: 50,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 850,
                showLabels: false,
                showTicks: false,
                radiusFactor: 1.7,
                centerY: 0.85,
                axisLineStyle: AxisLineStyle(
                  thickness: 0.1,
                  color: Colors.grey.withOpacity(0.1),
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0,
                    endValue: widget.value,
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.1,
                    endWidth: 0.1,
                    gradient: const SweepGradient(
                      colors: [
                        Color(0xFFFF6B78),
                        Color(0xFF6C5CE7),
                      ],
                      stops: [0.25, 0.75]
                    ),
                  )
                ],
                startAngle: 180,
                endAngle: 0,
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    axisValue: 425,
                    positionFactor: 0,
                    verticalAlignment: GaugeAlignment.far,
                    widget: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Good',
                          style: TextStyle(
                            fontSize: 5,
                            color: Color(0xFF6C5CE7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${widget.value.toInt()}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Text(
                          '0 pts',
                          style: TextStyle(
                            fontSize: 5,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
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