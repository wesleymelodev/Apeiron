package com.ancrolyn.apeiron.apeiron

import android.service.wallpaper.WallpaperService
import android.graphics.Canvas
import android.graphics.BitmapFactory
import android.graphics.Bitmap
import android.graphics.Matrix
import android.graphics.Color
import android.os.Handler
import android.os.Looper
import android.view.SurfaceHolder
import android.content.Context

class ApeironWallpaperService : WallpaperService() {

    override fun onCreateEngine(): Engine {
        return SlideshowEngine()
    }

    inner class SlideshowEngine : Engine() {
        private val handler = Handler(Looper.getMainLooper())
        private var visible = false
        private var currentIndex = 0

        private val drawRunnable = object : java.lang.Runnable {
            override fun run() {
                if (!visible) return

                val paths = loadPathsFromPrefs()
                if (paths.isNotEmpty()) {
                    if (currentIndex >= paths.size) currentIndex = 0
                    drawFrame(paths[currentIndex])
                    currentIndex++
                }
                handler.postDelayed(this, 10000) // Troca a cada 10s
            }
        }

        override fun onVisibilityChanged(visible: Boolean) {
            this.visible = visible
            if (visible) {
                handler.post(drawRunnable)
            } else {
                handler.removeCallbacks(drawRunnable)
            }
        }

        private fun loadPathsFromPrefs(): List<String> {
            val sharedPref = applicationContext.getSharedPreferences("ApeironPrefs", Context.MODE_PRIVATE)
            return sharedPref.getStringSet("image_paths", emptySet())?.toList() ?: emptyList()
        }

        private fun drawFrame(imagePath: String) {
            val holder = surfaceHolder
            var canvas: Canvas? = null
            try {
                canvas = holder.lockCanvas()
                if (canvas != null) {
                    val bitmap = BitmapFactory.decodeFile(imagePath)
                    if (bitmap != null) {
                        renderBitmapCentered(canvas, bitmap)
                    } else {
                        canvas.drawColor(Color.BLACK)
                    }
                }
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                if (canvas != null) holder.unlockCanvasAndPost(canvas)
            }
        }

        private fun renderBitmapCentered(canvas: Canvas, bitmap: Bitmap) {
            val canvasWidth = canvas.width.toFloat()
            val canvasHeight = canvas.height.toFloat()
            val bitmapWidth = bitmap.width.toFloat()
            val bitmapHeight = bitmap.height.toFloat()

            val scale = Math.max(canvasWidth / bitmapWidth, canvasHeight / bitmapHeight)
            val x = (canvasWidth - bitmapWidth * scale) / 2f
            val y = (canvasHeight - bitmapHeight * scale) / 2f

            val matrix = Matrix()
            matrix.postScale(scale, scale)
            matrix.postTranslate(x, y)

            canvas.drawColor(Color.BLACK)
            canvas.drawBitmap(bitmap, matrix, null)
        }
    }
}