import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:trash_collector/models/bin_model.dart';
import 'package:trash_collector/widgets/app_bar.dart';

class BinDetails extends StatefulWidget {
  final BinModel bin;
  const BinDetails({Key? key, required this.bin}) : super(key: key);
 
  @override
  State<BinDetails> createState() => _BinDetailsState();
}

class _BinDetailsState extends State<BinDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade900,
            Colors.blue.shade800,
            Colors.blue.shade700,
            Colors.blue.shade600,
          ],
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: GlobalAppBar(context, title: 'Bin Details', chatcreen: false),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const Text("Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(width: 10),
                                Text(widget.bin.name ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white54)),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(width: 10),
                                Text(widget.bin.address ?? '',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white60)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                        height: 600,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance.collection('sensorData').doc(widget.bin.id).snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                var snapshotData = (snapshot.data as DocumentSnapshot).data();
                                Map data = snapshotData == null ? {'weight': 0.0, 'inch': 0.0} : snapshotData as Map;
                                print(data);
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: SfRadialGauge(
                                          enableLoadingAnimation: true,
                                          title: const GaugeTitle(
                                              text: 'Bin Weight',
                                              textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
                                          axes: <RadialAxis>[
                                            RadialAxis(minimum: 0, maximum: 6, ranges: <GaugeRange>[
                                              GaugeRange(startValue: 0, endValue: 2, color: Colors.green),
                                              GaugeRange(startValue: 2, endValue: 4, color: Colors.orange),
                                              GaugeRange(startValue: 4, endValue: 6, color: Colors.red)
                                            ], pointers: <GaugePointer>[
                                              NeedlePointer(enableAnimation: true, value: double.parse((data['weight'] / 1000.0).toStringAsFixed(2)))
                                            ], annotations: <GaugeAnnotation>[
                                              GaugeAnnotation(
                                                widget: Padding(
                                                  padding: const EdgeInsets.only(top: 100),
                                                  child: Text((data['weight'] / 1000.0).toStringAsFixed(2) + ' Kg',
                                                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
                                                ),
                                                angle: double.parse((data['weight'] / 1000.0).toStringAsFixed(2)),
                                              )
                                            ])
                                          ]),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                          child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Bin Consumpstion",
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                          ),
                                          const SizedBox(height: 10),
                                          SfLinearGauge(
                                            animateAxis: true,
                                            animateRange: true,
                                            minimum: 0.0,
                                            maximum: 7.0,
                                            useRangeColorForAxis: true,
                                            markerPointers: [
                                              LinearShapePointer(
                                                value: double.parse(data['inch'].toString()),
                                              ),
                                            ],
                                            barPointers: [
                                              LinearBarPointer(
                                                value: double.parse(data['inch'].toString()),
                                              )
                                            ],
                                          ),
                                        ],
                                      )),
                                    )
                                  ],
                                );
                              }),
                        )),
                  )),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
