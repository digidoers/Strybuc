package com.example.strybuc

import android.app.Activity
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.MotionEvent
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.ar.core.Anchor
import com.google.ar.core.HitResult
import com.google.ar.core.Plane
import com.google.ar.sceneform.AnchorNode
import com.google.ar.sceneform.FrameTime
import com.google.ar.sceneform.Node
import com.google.ar.sceneform.math.Quaternion
import com.google.ar.sceneform.math.Vector3
import com.google.ar.sceneform.rendering.Color
import com.google.ar.sceneform.rendering.MaterialFactory
import com.google.ar.sceneform.rendering.ShapeFactory
import com.google.ar.sceneform.rendering.ViewRenderable
import java.text.DecimalFormat
import kotlin.math.sqrt
import com.google.ar.core.Config
import io.flutter.plugin.common.MethodChannel
import android.view.View
import android.graphics.Bitmap
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.view.PixelCopy
import android.view.SurfaceView
import java.util.*
import java.io.File
import java.io.FileOutputStream
import java.text.SimpleDateFormat
import android.widget.Toast

data class AnchorInfoBean(
  var dataText: String,
  var anchor: Anchor,
  var length: Double
)

class ARMeasurementActivity : AppCompatActivity() {
  val metersToInches = 39.3701
  val df = DecimalFormat("#.##")

  private val btnClear by lazy { findViewById<TextView>(R.id.btn_start) }

  private val captureButton by lazy { findViewById<TextView>(R.id.capture_btn) }

  private var arFragment: CustomArFragment? = null

  private val dataArray = arrayListOf<AnchorInfoBean>()
  private val sphereNodeArray = arrayListOf<Node>()
  private var startNode: AnchorNode? = null
  private var endNode: AnchorNode? = null
  private var lineNode: Node? = null
  private val screenshotPaths = mutableListOf<String>()
  private var screenshotCount: Int = 0

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_ar_measurement)
    arFragment = supportFragmentManager.findFragmentById(R.id.sceneform_fragment) as CustomArFragment?
    arFragment?.setOnTapArPlaneListener { hitResult, plane, motionEvent ->
      tapPlane(hitResult, plane, motionEvent)
    }
    val resultIntent = Intent()
    screenshotCount = resultIntent.getIntExtra("screenshotCount", 0)
    Log.d("ARMeasurementActivity", "Screenshot Limit: $screenshotCount")

    btnClear.setOnClickListener {
      clearAllNodes()
    }

    captureButton.setOnClickListener {
      captureScreenshot()
      Log.d("ARMeasurementActivity", "captureButton.setOnClickListener")
    }
  }

  private fun captureScreenshot() {
    // Get the AR SceneView from the fragment
    val arSceneView = arFragment?.arSceneView ?: run {
      Log.e("ARMeasurementActivity", "AR SceneView is null")
      return
    }

    // Create a Bitmap with the same dimensions as the AR SceneView
    val bitmap = Bitmap.createBitmap(arSceneView.width, arSceneView.height, Bitmap.Config.ARGB_8888)

    // Use a Handler on the main looper for PixelCopy
    val handler = Handler(Looper.getMainLooper())

    PixelCopy.request(arSceneView, bitmap, { copyResult ->
      if (copyResult == PixelCopy.SUCCESS) {
        // Save the bitmap and add the path to our list
        val savedPath = saveScreenshot(bitmap)
        if (savedPath != null) {
          screenshotPaths.add(savedPath)
          Log.d("ARMeasurementActivity", "Screenshot saved: ${screenshotPaths.size}")
          runOnUiThread {
            Toast.makeText(this, "Screenshot captured!", Toast.LENGTH_SHORT).show()
          }
          // increment screenshot limit
//          if(screenshotCount == 6) {
            sendResultAndClose()
//          }
        }
      } else {
        Log.e("ARMeasurementActivity", "PixelCopy failed with result: $copyResult")
        runOnUiThread {
          Toast.makeText(this, "Failed to capture screenshot", Toast.LENGTH_SHORT).show()
        }
      }
    }, handler)
  }

  /**
   * Save the captured Bitmap as a PNG file and return its absolute path.
   */
  private fun saveScreenshot(bitmap: Bitmap): String? {
    return try {
      val timestamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(Date())
      val fileName = "AR_Screenshot_$timestamp.png"
      val directory = getExternalFilesDir(Environment.DIRECTORY_PICTURES)
      if (directory != null && !directory.exists()) {
        directory.mkdirs()
      }
      val file = File(directory, fileName)
      val outputStream = FileOutputStream(file)
      bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
      outputStream.flush()
      outputStream.close()
      file.absolutePath
    } catch (e: Exception) {
      e.printStackTrace()
      null
    }
  }

  private fun sendResultAndClose() {
    val resultIntent = Intent()
    resultIntent.putStringArrayListExtra("screenshots", ArrayList(screenshotPaths))
    setResult(Activity.RESULT_OK, resultIntent)
    finish() // Close AR Activity and return to Flutter
  }

  override fun onResume() {
    super.onResume()
    arFragment?.arSceneView?.session?.let { session ->
      val config = session.config
      config.focusMode = Config.FocusMode.AUTO // Explicitly enable autofocus
      session.configure(config)
      Log.d("ARMeasurementActivity", "Autofocus explicitly enabled in onResume()")
    }
  }

  private fun tapPlane(hitResult: HitResult, plane: Plane, motionEvent: MotionEvent) {
    if (arFragment == null) return
    val anchorInfoBean = AnchorInfoBean("", hitResult.createAnchor(), 0.0)
    dataArray.add(anchorInfoBean)


    if (startNode == null || endNode != null) {
      if (endNode != null) {
        clearAllNodes()
      }
      startNode = AnchorNode(hitResult.createAnchor())
      startNode!!.setParent((arFragment!!).arSceneView.scene)
      MaterialFactory.makeOpaqueWithColor(this, Color(0.33f, 0.87f, 0f))
        .thenAccept { material ->
          val sphere = ShapeFactory.makeSphere(0.01f, Vector3.zero(), material)
          sphereNodeArray.add(Node().apply {
            setParent(startNode)
            localPosition = Vector3.zero()
            renderable = sphere
          })
        }
    } else {
      endNode = AnchorNode(hitResult.createAnchor())
      endNode!!.setParent((arFragment!!).arSceneView.scene)
      MaterialFactory.makeOpaqueWithColor(this, Color(0.33f, 0.87f, 0f))
        .thenAccept { material ->
          val sphere = ShapeFactory.makeSphere(0.01f, Vector3.zero(), material)
          sphereNodeArray.add(Node().apply {
            setParent(endNode)
            localPosition = Vector3.zero()
            renderable = sphere
          })
        }

      val endAnchor = endNode!!.anchor
      val startAnchor = startNode!!.anchor

      val startPose = endAnchor!!.pose
      val endPose = startAnchor!!.pose
      val dx = startPose.tx() - endPose.tx()
      val dy = startPose.ty() - endPose.ty()
      val dz = startPose.tz() - endPose.tz()

      anchorInfoBean.length = sqrt((dx * dx + dy * dy + dz * dz).toDouble())

      drawLine(startNode!!, endNode!!, anchorInfoBean.length)
    }

  }

  private fun drawLine(firstAnchorNode: AnchorNode, secondAnchorNode: AnchorNode, length: Double) {
    if (arFragment == null) return
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {

      val firstWorldPosition = firstAnchorNode.worldPosition
      val secondWorldPosition = secondAnchorNode.worldPosition

      val difference = Vector3.subtract(firstWorldPosition, secondWorldPosition)
      val directionFromTopToBottom = difference.normalized()
      val rotationFromAToB = Quaternion.lookRotation(directionFromTopToBottom, Vector3.up())

      MaterialFactory.makeOpaqueWithColor(this, Color(0.33f, 0.87f, 0f))
        .thenAccept { material ->
          val lineMode = ShapeFactory.makeCube(Vector3(0.005f, 0.005f, difference.length()), Vector3.zero(), material)
          lineNode = Node().apply {
            setParent(firstAnchorNode)
            renderable = lineMode
            worldPosition = Vector3.add(firstWorldPosition, secondWorldPosition).scaled(0.5f)
            worldRotation = rotationFromAToB
          }

          ViewRenderable.builder()
            .setView(this, R.layout.renderable_text)
            .build()
            .thenAccept {
              val inch = df.format(length * metersToInches)
              Log.i("ARMeasurementActivity", "drawLine-130: $length m $inch inches")
              (it.view as TextView).text = inch + " inches"
              it.isShadowCaster = false
              FaceToCameraNode().apply {
                setParent(lineNode)
                localRotation = Quaternion.axisAngle(Vector3(0f, 1f, 0f), 90f)
                localPosition = Vector3(0f, 0.02f, 0f)
                renderable = it
              }
            }
        }
    }
  }

  fun clearAllNodes() {
    startNode?.let {
      for (i in it.children.indices.reversed()) {
        val node = it.children[i]
        for (j in node.children.indices.reversed()) {
          val node1 = node.children[j]
          node.removeChild(node1)
        }
        it.removeChild(node)
      }
      arFragment?.arSceneView?.scene?.removeChild(it)
    }
    endNode?.let {
      for (i in it.children.indices.reversed()) {
        val node = it.children[i]
        for (j in node.children.indices.reversed()) {
          val node1 = node.children[j]
          node.removeChild(node1)
        }
        it.removeChild(node)
      }
      arFragment?.arSceneView?.scene?.removeChild(it)
    }
    startNode = null
    endNode = null
    lineNode = null
  }

  override fun onDestroy() {
    super.onDestroy()
    arFragment?.onDestroy()
  }
}

class FaceToCameraNode : Node() {
  override fun onUpdate(p0: FrameTime?) {
    scene?.let { scene ->
      val cameraPosition = scene.camera.worldPosition
      val nodePosition = this@FaceToCameraNode.worldPosition
      val direction = Vector3.subtract(cameraPosition, nodePosition)
      this@FaceToCameraNode.worldRotation = Quaternion.lookRotation(direction, Vector3.up())
    }
  }
}