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
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 800,
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(
            thickness: 0.2,
            color: Colors.white,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: widget.value,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
              enableAnimation: true,
              animationDuration: 1000,
              color: Colors.red,
            ),
          ],
          startAngle: 160,
          endAngle: 370,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                '${widget.value.toInt()}',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              positionFactor: 0.1,
              angle: 270,
            )
          ],
        )
      ],
    );
  }
}