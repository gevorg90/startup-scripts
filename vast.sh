#!/bin/bash

# Redirect all output (stdout and stderr) to /workspace/startup.log
exec > /workspace/startup.log 2>&1

# Create comfyui directory and set up environment
mkdir -p /workspace/comfyui
cd /workspace/comfyui

python -m venv venv
source venv/bin/activate

# Install required packages
pip install comfy-cli
echo "y" | comfy --here install --nvidia
pip install bitsandbytes "accelerate>=0.26.0" sageattention==1.0.6

# Download checkpoints
cd /workspace/comfyui/ComfyUI/models/checkpoints
wget https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-19b-distilled-fp8.safetensors

# Download latent upscale models
#cd /workspace/comfyui/ComfyUI/models/latent_upscale_models
#wget https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-spatial-upscaler-x2-1.0.safetensors

# Clone text encoder
#cd /workspace/comfyui/ComfyUI/models/text_encoders
#git clone https://huggingface.co/unsloth/gemma-3-12b-it-bnb-4bit

# Prepare start script
cd /workspace
mkdir -p start
cd start
wget https://s3.us-west-1.wasabisys.com/ai-generator-models/wan-video/start.sh
chmod +x start.sh

# Download unet models
#cd /workspace/comfyui/ComfyUI/models/unet
#wget https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/T2V/Wan2_2-T2V-A14B_HIGH_fp8_e4m3fn_scaled_KJ.safetensors
#wget https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/T2V/Wan2_2-T2V-A14B-LOW_fp8_e4m3fn_scaled_KJ.safetensors
#wget https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/I2V/Wan2_2-I2V-A14B-LOW_fp8_e4m3fn_scaled_KJ.safetensors
#wget https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/I2V/Wan2_2-I2V-A14B-HIGH_fp8_e4m3fn_scaled_KJ.safetensors

# Download loras
#cd /workspace/comfyui/ComfyUI/models/loras
#wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22-Lightning/old/Wan2.2-Lightning_T2V-v1.1-A14B-4steps-lora_HIGH_fp16.safetensors
#wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22-Lightning/old/Wan2.2-Lightning_T2V-v1.1-A14B-4steps-lora_LOW_fp16.safetensors
#wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22-Lightning/old/Wan2.2-Lightning_I2V-A14B-4steps-lora_LOW_fp16.safetensors
#wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22-Lightning/old/Wan2.2-Lightning_I2V-A14B-4steps-lora_HIGH_fp16.safetensors

# Download text encoder model
#cd /workspace/comfyui/ComfyUI/models/text_encoders
#wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors

# Download VAE
#cd /workspace/comfyui/ComfyUI/models/vae
#wget https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors -O Wan2.1_VAE.safetensors
