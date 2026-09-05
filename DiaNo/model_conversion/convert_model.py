import tensorflow as tf
import os

def convert_model():
    # Get the current directory
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Construct full path to the model
    model_path = os.path.join(current_dir, 'keras_model.h5')
    
    print(f"Loading model from: {model_path}")
    
    # Original .h5 model load karein
    model = tf.keras.models.load_model(model_path)

    # Create models directory if it doesn't exist
    assets_dir = os.path.join(os.path.dirname(current_dir), 'assets', 'models')
    os.makedirs(assets_dir, exist_ok=True)
    
    output_path = os.path.join(assets_dir, 'retinopathy_model.tflite')
    
    # TFLite Converter initialize karein
    converter = tf.lite.TFLiteConverter.from_keras_model(model)

    # Optimization settings
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.target_spec.supported_types = [tf.float16]

    print("Converting model to TFLite format...")
    
    # Convert karein
    tflite_model = converter.convert()

    print(f"Saving model to: {output_path}")
    
    # Save TFLite model
    with open(output_path, 'wb') as f:
        f.write(tflite_model)
    
    print("Model successfully converted and saved!")

if __name__ == "__main__":
    convert_model()