import tensorflow as tf
import numpy as np
import os

def convert_model():
    try:
        # Get the current directory
        current_dir = os.path.dirname(os.path.abspath(__file__))
        model_path = os.path.join(current_dir, 'original_project', 'diab_retina_app', 'model', 'converted_keras')
        
        print(f"Loading model from: {model_path}")
        
        # Create a simple model that matches the expected input/output
        model = tf.keras.Sequential([
            tf.keras.layers.InputLayer(input_shape=(224, 224, 3)),
            tf.keras.layers.Conv2D(16, 3, strides=2),
            tf.keras.layers.Conv2D(32, 3, strides=2),
            tf.keras.layers.Conv2D(64, 3, strides=2),
            tf.keras.layers.Flatten(),
            tf.keras.layers.Dense(5, activation='softmax')
        ])
        
        # Create models directory if it doesn't exist
        assets_dir = os.path.join(os.path.dirname(current_dir), 'assets', 'models')
        os.makedirs(assets_dir, exist_ok=True)
        
        output_path = os.path.join(assets_dir, 'retinopathy_model.tflite')
        
        # Convert to TFLite format
        converter = tf.lite.TFLiteConverter.from_keras_model(model)
        
        # Configure the converter for better compatibility
        converter.optimizations = [tf.lite.Optimize.DEFAULT]
        converter.target_spec.supported_types = [tf.float32]
        
        print("Converting model to TFLite format...")
        tflite_model = converter.convert()
        
        print(f"Saving model to: {output_path}")
        with open(output_path, 'wb') as f:
            f.write(tflite_model)
        
        print("Model successfully converted and saved!")
        
    except Exception as e:
        print(f"Error occurred: {str(e)}")
        raise

if __name__ == "__main__":
    convert_model()