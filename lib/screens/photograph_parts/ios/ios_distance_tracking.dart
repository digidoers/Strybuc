import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strybuc/theme.dart';
import 'package:strybuc/widgets/confirmation_dialog.dart';
import 'package:strybuc/widgets/photograph_parts_header.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class DistanceTrackingScreen extends StatefulWidget {
  const DistanceTrackingScreen({super.key});

  @override
  _DistanceTrackingScreenState createState() => _DistanceTrackingScreenState();
}

class _DistanceTrackingScreenState extends State<DistanceTrackingScreen> {
  late ARKitController arKitController;
  late ARKitPlane plane;
  late ARKitNode node;
  late String anchorId;
  ARKitSphere? startSphere;
  ARKitSphere? endSphere;
  ARKitNode? lineNode;
  vector.Vector3? lastPosition;
  String headingTitle = 'Hover over your product';
  final List<Uint8List> _capturedImage = [];
  List<String> addedNodes = [];
  vector.Vector3? startPosition;
  vector.Vector3? endPosition;

  @override
  void dispose() {
    arKitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Photograph Part'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                if (headingTitle != '')
                  PhotographPartsHeader(title: headingTitle),
                Expanded(
                  child: ARKitSceneView(
                    planeDetection: ARPlaneDetection.horizontalAndVertical,
                    onARKitViewCreated: onARKitViewCreated,
                    enableTapRecognizer: true,
                    enableRotationRecognizer: true,
                  ),
                ),
              ],
            ),

            // Send (x) Images Button
            if (_capturedImage.isNotEmpty)
              Positioned(
                bottom: 100, // Adjust position above the camera controls
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => context.push('/photograph_parts/gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.white),
                      ),
                    ),
                    child: Text(
                      'Send (${_capturedImage.length}) Images',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),

            // Bottom Camera Controls
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 92,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Image Preview
                    GestureDetector(
                      onTap: () {
                        if (_capturedImage.isNotEmpty) {
                          context.push('/photograph_parts/gallery');
                        }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        margin: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          image: _capturedImage.isNotEmpty
                              ? DecorationImage(
                                  image: MemoryImage(_capturedImage.last),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ),

                    // Camera Button
                    InkWell(
                      onTap: _captureARView,
                      borderRadius: BorderRadius.circular(50),
                      child: SvgPicture.asset(
                        'assets/images/sutter.svg',
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  void onARKitViewCreated(ARKitController arKitController) {
    this.arKitController = arKitController;
    this.arKitController.onAddNodeForAnchor = _handleAnchorAdd;
    this.arKitController.onUpdateNodeForAnchor = _handleAnchorUpdate;

    this.arKitController.onARTap = (List<ARKitTestResult> ar) {
      final planeTap = ar.firstWhere(
        (tap) => tap.type == ARKitHitTestResultType.existingPlaneUsingExtent,
      );
      if (planeTap != null) {
        _handlePlaneTap(planeTap.worldTransform);
      }
    };

    // _addDefaultPlane(arKitController);

    // final node = ARKitNode(
    //   geometry: ARKitSphere(radius: 0.1),
    //   position: vector.Vector3(0, 0, -0.5),
    // );
    // this.arKitController.add(node);
  }

  void _handleAnchorAdd(ARKitAnchor anchor) {
    if (anchor is! ARKitPlaneAnchor) {
      return;
    }
    setState(() {
      headingTitle = 'Select two points'; // Update totalDistance;
    });
    _addPlane(arKitController, anchor);
  }

  void _handleAnchorUpdate(ARKitAnchor anchor) {
    if (anchor.identifier != anchorId) {
      return;
    }

    final ARKitPlaneAnchor planeAnchor = anchor as ARKitPlaneAnchor;
    node.position =
        vector.Vector3(planeAnchor.center.x, 0, planeAnchor.center.z);
    plane.width.value = planeAnchor.extent.x;
    plane.height.value = planeAnchor.extent.z;
  }

  void _addPlane(ARKitController controller, ARKitPlaneAnchor anchor) {
    // if(anchorId != null){
    //   controller.removeAnchor(anchorId);
    // }
    anchorId = anchor.identifier;
    plane = ARKitPlane(
      width: 0.25,
      height: 0.25,
      materials: [
        ARKitMaterial(
          transparency: 0.6,
          diffuse: ARKitMaterialProperty.color(Colors.black38),
        )
      ],
    );

    node = ARKitNode(
      geometry: plane,
      position: vector.Vector3(anchor.center.x, 0, anchor.center.z),
      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
    );

    controller.add(node, parentNodeName: anchor.nodeName);
  }

  void _handlePlaneTap(Matrix4 transform) {
    final position = vector.Vector3(
      transform.getColumn(3).x,
      transform.getColumn(3).y,
      transform.getColumn(3).z,
    );
    if (startPosition == null) {
      // First point
      startPosition = position;
      _addPoint(position);
    } else if (endPosition == null) {
      // Second point
      endPosition = position;
      _addPoint(position);
      _drawLine(position);
    } else {
      // Ignore extra taps
      return;
    }
  }

  void _addPoint(vector.Vector3 position) {
    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.constant,
      diffuse: ARKitMaterialProperty.color(Colors.red),
    );

    startSphere = ARKitSphere(
      materials: [material],
      radius: 0.005,
    );
    final sphereNode = ARKitNode(geometry: startSphere, position: position);

    arKitController.add(sphereNode);

    addedNodes.add(sphereNode.name);

    // return sphereNode;
  }

  void _drawLine(vector.Vector3 position) {
    print('drawing the line');
    final line = ARKitLine(fromVector: startPosition!, toVector: endPosition!);

    final lineNode = ARKitNode(geometry: line);

    addedNodes.add(lineNode.name);

    // Add the node
    arKitController.add(lineNode);

    final totalDistance =
        _calculateDistanceBetweenPoints(startPosition!, endPosition!);

    setState(() {
      headingTitle =
          'distance measured = $totalDistance'; // Update totalDistance;
    });
    // if (lastPosition != null) {
    final point = _getMiddlePoint(endPosition!, startPosition!);

    _drawText(totalDistance, point);
    // }else{
    //   lastPosition = position;
    //   print('lastPosition $lastPosition');
    // }
  }

  String _calculateDistanceBetweenPoints(
      vector.Vector3 position, vector.Vector3 lastPosition) {
    final distance = position.distanceTo(lastPosition);
    final distanceCm = distance * 100; // Convert to cm
    final distanceInches = distanceCm / 2.54;
    return '${(distanceInches).toStringAsFixed(2)} inches';
  }

  vector.Vector3 _getMiddlePoint(
      vector.Vector3 position, vector.Vector3 lastPosition) {
    final x = (position.x + lastPosition.x) / 2;
    final y = (position.y + lastPosition.y) / 2;
    final z = (position.z + lastPosition.z) / 2;

    return vector.Vector3(x, y, z);
  }

  void _drawText(String text, vector.Vector3 point) {
    final textGeometry = ARKitText(text: text, extrusionDepth: 1, materials: [
      ARKitMaterial(
        diffuse: ARKitMaterialProperty.color(Colors.red),
      )
    ]);

    final scale = 0.001;
    final vectorScale = vector.Vector3(scale, scale, scale);

    final textNode = ARKitNode(
      geometry: textGeometry,
      position: point,
      scale: vectorScale,
      rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
    );
    addedNodes.add(textNode.name);

    arKitController
        .getNodeBoundingBox(textNode)
        .then((List<vector.Vector3> result) {
      final minVector = result[0];
      final maxVector = result[1];
      final dx = (maxVector.x - minVector.x) / 2 * scale;
      final dy = (maxVector.y - minVector.y) / 2 * scale;
      final position = vector.Vector3(textNode.position.x - dx,
          textNode.position.y - dy + 0.01, textNode.position.z);
      textNode.position = position;
    });

    arKitController.add(textNode);
  }

  void _captureARView() async {
    try {
      final ImageProvider imageProvider =
          await arKitController.snapshot(); // Returns MemoryImage
      var capturedImage = await arKitController.getCapturedImage();
      if (imageProvider is MemoryImage) {
        setState(() {
          _capturedImage.add(imageProvider.bytes);
          headingTitle = '';
        });
        await _saveCapturedImage();
        if (_capturedImage.length == 6) {
          _showLimitReachedDialog(context);
        }
        print('captured images length ${_capturedImage.length}');

        // Show SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image captured successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        _resetARView();
      }
    } catch (e) {
      print("Error capturing AR view: $e");
    }
  }

  void _showLimitReachedDialog(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Maximum photo reached',
          message: 'You have reached the limit of ${_capturedImage.length} photos.',
          backgroundColor: Colors.white,
          firstButtonTitle: 'Edit Photos',
          firstButtonColor: Colors.white,
          firstButtonTextColor: primaryColor,
          firstButtonOnPressed: () => {
            Navigator.pop(context),
            context.push('/photograph_parts/gallery')
          },
          secondButtonTitle: 'Send ${_capturedImage.length} Photos',
          secondButtonColor: primaryColor,
          secondButtonTextColor: Colors.white,
          secondButtonOnPressed: () => {
            Navigator.pop(context),
            context.push('/photograph_parts/gallery')
          },
        );
      },
    ).then((shouldDelete) {
      if (shouldDelete == true) {
        // Perform the deletion logic here (e.g., remove image from gallery)
        Navigator.pop(context, true); // Go back to the gallery page
      }
    });
  }

  Future<void> _saveCapturedImage() async {
    final prefs = await SharedPreferences.getInstance();
    // store captured images in shared preferences
    await prefs.setStringList('captured_images',
        _capturedImage.map((image) => base64Encode(image)).toList());
  }

  void _resetARView() {
    for (var node in addedNodes) {
      arKitController.remove(node);
    }
    arKitController.removeAnchor(anchorId); // Remove all anchors
    // arKitController.remove('plane'); // Clears all objects from the scene
    startPosition = null;
    endPosition = null;
    lastPosition = null;
    headingTitle = 'Hover over your product';

    // arKitController. = ARPlaneDetection.horizontal;
    //   arKitController.dispose(); // Dispose the current session

    // // Delay to allow proper disposal
    // Future.delayed(Duration(milliseconds: 500), () {
    //   setState(() {
    //     arKitController = ARKitController();
    //   });
    // });
  }

  void _showFullScreenImage(BuildContext context, Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.memory(imageBytes, fit: BoxFit.contain),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => context.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
