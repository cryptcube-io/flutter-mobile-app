import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../config/api_endpoints.dart';
import '../../pages/score/privacy_score_detail.dart';
import '../../../icons/privacy_score_gauge.dart';


class PrivacyScoreSection extends StatefulWidget {
 final String token;
 
 const PrivacyScoreSection({super.key, required this.token});

 @override
 State<PrivacyScoreSection> createState() => _PrivacyScoreSectionState();
}

class _PrivacyScoreSectionState extends State<PrivacyScoreSection> {
 int privacyScore = 0;
 bool isLoading = true;

 @override
 void initState() {
   super.initState();
   fetchPrivacyScore();
 }

 Future<void> fetchPrivacyScore() async {
   final dio = Dio();
   try {
     final response = await dio.get(
       ApiEndpoints.getOverallPrivacyScore,
       options: Options(
         headers: {
           'Authorization': 'Bearer ${widget.token}',
         },
       ),
     );

     if (response.statusCode == 200) {
       setState(() {
         privacyScore = response.data;
         isLoading = false;
       });
     } else {
       setState(() {
         isLoading = false;
       });
     }
   } catch (e) {
     setState(() {
       isLoading = false;
     });
   }
 }

 @override
 Widget build(BuildContext context) {
   return Column(
     children: [
       Center(
         child: GestureDetector(
           onTap: () {},
           child: Container(
             width: 200,
             height: 200,
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               color: Colors.white,
               boxShadow: [
                 BoxShadow(
                   color: Colors.grey.withOpacity(0.2),
                   spreadRadius: 5,
                   blurRadius: 7,
                   offset: const Offset(0, 3),
                 ),
               ],
             ),
             child: Stack(
               clipBehavior: Clip.none,
               children: [
                 Positioned(
                   left: -20,
                   right: -20,
                   top: -20,
                   bottom: -20,
                   child: Container(
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       color: Colors.white.withOpacity(0.4),
                     ),
                   ),
                 ),
                 isLoading
                     ? const Center(child: CircularProgressIndicator())
                     : SimpleRadialGauge(value: privacyScore.toDouble()),
               ],
             ),
           ),
         ),
       ),
       const SizedBox(height: 20),
       Center(
         child: TextButton(
           onPressed: () => Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => const PrivacyScoreDetail(),
             ),
           ),
           style: TextButton.styleFrom(
             backgroundColor: Colors.grey[100],
             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(20),
             ),
           ),
           child: Row(
             mainAxisSize: MainAxisSize.min,
             children: const [
               Text(
                 'See How You Scored',
                 style: TextStyle(
                   color: Colors.black87,
                   fontSize: 16,
                 ),
               ),
               SizedBox(width: 8),
               Icon(Icons.arrow_forward, size: 20, color: Colors.black87),
             ],
           ),
         ),
       ),
     ],
   );
 }
}