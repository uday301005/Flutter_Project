import tensorflow as tf
import os

def convert_model():
    try:
        # Get the current directory
        current_dir = os.path.dirname(os.path.abspath(__file__))
        model_path = os.path.join(current_dir, 'original_project', 'diab_retina_app', 'keras_model.h5')
        
        print(f"Loading model from: {model_path}")
        
        # Load the model in a version-agnostic way
        model = tf.saved_model.load(model_path)
        
        # Create models directory if it doesn't exist
        assets_dir = os.path.join(os.path.dirname(current_dir), 'assets', 'models')
        os.makedirs(assets_dir, exist_ok=True)
        
        output_path = os.path.join(assets_dir, 'retinopathy_model.tflite')
        
        # Convert to TFLite format
        converter = tf.lite.TFLiteConverter.from_saved_model(model_path)
        
        # Configure the converter
        converter.optimizations = [tf.lite.Optimize.DEFAULT]
        converter.target_spec.supported_types = [tf.float32]
        converter.target_spec.supported_ops = [
            tf.lite.OpsSet.TFLITE_BUILTINS,
            tf.lite.OpsSet.SELECT_TF_OPS
        ]
        
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