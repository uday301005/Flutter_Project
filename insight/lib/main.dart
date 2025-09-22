import 'package:flutter/material.dart';

import 'first.dart';

// Reusable text styles for this screen
const TextStyle kMutedDarkLabel18 = TextStyle(
	color: Color(0xFF2F2F2F),
	fontSize: 18,
	fontFamily: 'Space Grotesk',
	fontWeight: FontWeight.w600,
	height: 1.22,
);

const TextStyle kHeadlineWhite24 = TextStyle(
	color: Colors.white,
	fontSize: 24,
	fontFamily: 'Space Grotesk',
	fontWeight: FontWeight.w600,
	height: 1.50,
);

void main() {
	runApp(const InsightApp());
}

class InsightApp extends StatelessWidget {
	const InsightApp({super.key});

	@override
	Widget build(BuildContext context) {
		return const MaterialApp(
			debugShowCheckedModeBanner: false,
			home: First(),
			// MasterScreen(),
		);
	}
}

class MasterScreen extends StatefulWidget {
	const MasterScreen({super.key});

	@override
	State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(

			body: LayoutBuilder(
				builder: (context, constraints) {
					const double designWidth = 428;
					const double designHeight = 926;
					final double scaleW = constraints.maxWidth / designWidth;
					final double scaleH = constraints.maxHeight / designHeight;
					final double s = scaleW < scaleH ? scaleW : scaleH;

					final TextStyle headline24 = kHeadlineWhite24.copyWith(fontSize: 24 * s);
					final TextStyle label18 = kMutedDarkLabel18.copyWith(fontSize: 18 * s);

					double sw(double x) => x * scaleW;
					double sh(double y) => y * scaleH;

					return Container(
						width: double.infinity,
						height: double.infinity,
						clipBehavior: Clip.antiAlias,
						decoration: const BoxDecoration(color: Color(0xFF121212)),
						child: Stack(
							children: [
								Positioned(
									left: sw(189),
									top: sh(754.53),
									child: Container(
										transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-0.38),
										width: sw(92.65),
										height: sh(92.65),
										decoration: ShapeDecoration(
											color: const Color(0xFF45C588),
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(12 * s),
											),
										),
									),
								),
								Positioned(
									left: sw(215.59),
									top: sh(765.64),
									child: Text('Healthy', textAlign: TextAlign.center,
											style: label18),
								),
								Positioned(
									left: sw(133),
									top: sh(156),
									child: SizedBox(
										width: sw(162),
										height: sh(54),
									),
								),
								Positioned(
									left: sw(29),
									top: sh(907.49),
									child: Container(
										transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-1.47),
										padding: EdgeInsets.symmetric(horizontal: 24 * s, vertical: 10 * s),
										decoration: ShapeDecoration(
											color: const Color(0xFF45C588),
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(30 * s),
											),
										),
										child: Row(
											mainAxisSize: MainAxisSize.min,
											mainAxisAlignment: MainAxisAlignment.center,
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												Text('Today', textAlign: TextAlign.center, style: label18),
											],
										),
									),
								),
								Positioned(
									left: sw(117),
									top: sh(250),
									child: Text('Eating                  \nmade easy!', textAlign: TextAlign.center, style: headline24),
								),
								Positioned(
									left: sw(198),
									top: sh(250),
									child: Container(
										padding: EdgeInsets.symmetric(horizontal: 15 * s),
										decoration: ShapeDecoration(
											color: const Color(0xFFFF6F43),
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(50 * s),
											),
										),
										child: Row(
											mainAxisSize: MainAxisSize.min,
											mainAxisAlignment: MainAxisAlignment.center,
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												Text('healthy', textAlign: TextAlign.center, style: headline24),
											],
										),
									),
								),
							],
						),
					);
				},
			),
		);
	}
}
