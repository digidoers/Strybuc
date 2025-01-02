import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class DistanceTrackingPage extends StatefulWidget {
  const DistanceTrackingPage({super.key});

  @override
  _DistanceTrackingPageState createState() => _DistanceTrackingPageState();
}

class _DistanceTrackingPageState extends State<DistanceTrackingPage> {
  late ARKitController arKitController;
  late ARKitPlane plane;
  late ARKitNode node;
  late String anchorId;
  vector.Vector3? lastPosition;

  @override
  void dispose() {
    arKitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Strybuc Flutter'),
        ),
        body: Container(
          child: ARKitSceneView(
            planeDetection: ARPlaneDetection.horizontal,
            onARKitViewCreated: onARKitViewCreated,
            enableTapRecognizer: true,
            enableRotationRecognizer: true,
          ),
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

  void _addDefaultPlane(ARKitController controller) {
    // Create a default plane and place it in front of the camera
    plane = ARKitPlane(
      width: 0.3, // Width of the plane (1 meter)
      height: 0.25, // Height of the plane (1 meter)
      materials: [
        ARKitMaterial(
          transparency: 0.4,
          diffuse: ARKitMaterialProperty.color(Colors.white10),
        )
      ],
    );

    // Position the plane in front of the camera, centered on the screen
    node = ARKitNode(
      geometry: plane,
      position: vector.Vector3(0, 0,
          -0.5), // Fixed position in front of the camera (0.5 meters away)
      // rotation: vector.Vector4(
      //     1, 0, 0, -math.pi / 2), // Rotate to make the plane horizontal
    );

    // Add the node with the plane geometry to the scene
    controller.add(node);

    // controller.onCameraDidChangeTrackingState = (ARTrackingState trackingState) {
    //   print(trackingState);
    //   controller.getCameraEulerAngles().then((cameraTransform){
    //     print(cameraTransform);
    //   //    node.position = vector.Vector3(
    //   //   cameraTransform.translation.x, // X-axis position
    //   //   cameraTransform.translation.y, // Y-axis position
    //   //   cameraTransform.translation.z - 0.5, // Z-axis 0.5m in front
    //   // );
    //   });
      
    // } as Function(ARTrackingState trackingState, ARTrackingStateReason? reason)?;

    controller.onNodeTap = (nodes){
      print('Plane tapped!');
    //   if (nodes.first.name == node.name) {
    //   _handlePlaneTap(); // Call your custom tap handler
    // }
    };
  }

  void _handleAnchorAdd(ARKitAnchor anchor) {
    if (anchor is! ARKitPlaneAnchor) {
      return;
    }

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
    anchorId = anchor.identifier;
    plane = ARKitPlane(
      width: anchor.extent.x,
      height: anchor.extent.z,
      materials: [
        ARKitMaterial(
          transparency: 0.5,
          diffuse: ARKitMaterialProperty.color(Colors.white),
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

    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.constant,
      diffuse: ARKitMaterialProperty.color(Color.fromRGBO(255, 153, 83, 1)),
    );

    final sphere = ARKitSphere(
      materials: [material],
      radius: 0.003,
    );

    final sphereNode = ARKitNode(geometry: sphere, position: position);

    arKitController.add(sphereNode);
    if (lastPosition != null) {
      final line = ARKitLine(fromVector: lastPosition!, toVector: position);

      final lineNode = ARKitNode(geometry: line);
      arKitController.add(lineNode);

      final distance = _calculateDistanceBetweenPoints(position, lastPosition!);

      final point = _getMiddlePoint(position, lastPosition!);

      _drawText(distance, point);
    }
    lastPosition = position;
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
}
