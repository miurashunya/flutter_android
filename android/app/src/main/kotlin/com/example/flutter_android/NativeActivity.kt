package com.example.flutter_android

import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

class NativeActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // レイアウトをセット
        setContentView(R.layout.activity_native)

        // ボタンのクリックでFlutter画面に戻る
        val button = findViewById<Button>(R.id.button_return)
        button.setOnClickListener {
            finish()
        }
    }
}
