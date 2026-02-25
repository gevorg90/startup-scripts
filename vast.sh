#!/bin/bash

echo '___Starting___'
source /venv/main/bin/activate
# Redirect all output (stdout and stderr) to /workspace/startup.log
exec > /workspace/startup.log 2>&1

# Create comfyui directory and set up environment
mkdir -p /workspace/comfyui
cd /workspace/comfyui

python3 -m venv venv
source venv/bin/activate

echo 'Install required packages'
echo 'installing comfy-cli'
pip install comfy-cli
echo 'installing comfy'
yes | comfy --here install --nvidia
echo 'install pip packages'
pip install bitsandbytes "accelerate>=0.26.0" sageattention==1.0.6

echo 'Download checkpoints'
cd /workspace/comfyui/ComfyUI/models/checkpoints
wget https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-19b-distilled-fp8.safetensors

echo 'Download latent upscale models'
cd /workspace/comfyui/ComfyUI/models/latent_upscale_models
wget https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-spatial-upscaler-x2-1.0.safetensors

echo "Clone text encoder"
cd /workspace/comfyui/ComfyUI/models/text_encoders
git clone https://huggingface.co/unsloth/gemma-3-12b-it-bnb-4bit

echo 'Prepare start script'
cd /workspace
mkdir -p start
cd start
wget https://s3.us-west-1.wasabisys.com/ai-generator-models/wan-video/start.sh
chmod +x start.sh

echo 'Download unet models'
cd /workspace/comfyui/ComfyUI/models/unet
wget https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/T2V/Wan2_2-T2V-A14B_HIGH_fp8_e4m3fn_scaled_KJ.safetensors
wget https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/T2V/Wan2_2-T2V-A14B-LOW_fp8_e4m3fn_scaled_KJ.safetensors
wget https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/I2V/Wan2_2-I2V-A14B-LOW_fp8_e4m3fn_scaled_KJ.safetensors
wget https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/I2V/Wan2_2-I2V-A14B-HIGH_fp8_e4m3fn_scaled_KJ.safetensors

echo 'Download loras'
cd /workspace/comfyui/ComfyUI/models/loras
wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22-Lightning/old/Wan2.2-Lightning_T2V-v1.1-A14B-4steps-lora_HIGH_fp16.safetensors
wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22-Lightning/old/Wan2.2-Lightning_T2V-v1.1-A14B-4steps-lora_LOW_fp16.safetensors
wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22-Lightning/old/Wan2.2-Lightning_I2V-A14B-4steps-lora_LOW_fp16.safetensors
wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22-Lightning/old/Wan2.2-Lightning_I2V-A14B-4steps-lora_HIGH_fp16.safetensors

echo 'Download text encoder model'
cd /workspace/comfyui/ComfyUI/models/text_encoders
wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors

echo 'Download VAE'
cd /workspace/comfyui/ComfyUI/models/vae
wget https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors -O Wan2.1_VAE.safetensors


echo 'Download and install custom nodes from LTX workflow'
cd /workspace

echo 'Install ComfyUI-LTXVideo'
comfy node install ComfyUI-LTXVideo

echo 'Installing comfy node install ComfyMath'
comfy node install ComfyMath

echo 'Installing ComfyUI-load-image-from-url'
comfy node install ComfyUI-load-image-from-url

echo 'Installing ComfyUI_LoadImageFromHttpURL'
comfy node install ComfyUI_LoadImageFromHttpURL

cd /workspace/comfyui
cd ComfyUI/custom_nodes

echo 'Installing ComfyUI-Impact-Pack from git'
git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack 
pip install -r ComfyUI-Impact-Pack/requirements.txt

echo 'Installing ComfyUI-VideoHelperSuite'
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
pip install -r ComfyUI-VideoHelperSuite/requirements.txt

echo 'Installing ComfyUI_essentials'
git clone https://github.com/cubiq/ComfyUI_essentials
pip install -r ComfyUI_essentials/requirements.txt

echo 'Installing ComfyUI-Kimara-AI-Advanced-Watermarks'
git clone https://github.com/kimara-ai/ComfyUI-Kimara-AI-Advanced-Watermarks
pip install -r ComfyUI-Kimara-AI-Advanced-Watermarks/requirements.txt

echo 'Installing custom nodes from WAN forkflow'
cd /workspace
echo 'Install ComfyUI-WanVideoWrapper'
comfy node install ComfyUI-WanVideoWrapper

cd /workspace/comfyui
cd ComfyUI/custom_nodes

echo 'Install ComfyUI-Frame-Interpolation'
git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation
pip install -r ComfyUI-Frame-Interpolation/requirements-with-cupy.txt

echo 'Install ComfyUI-FlashVSR_Ultra_Fast'
git clone https://github.com/lihaoyun6/ComfyUI-FlashVSR_Ultra_Fast
pip install -r ComfyUI-FlashVSR_Ultra_Fast/requirements.txt

echo 'Install ComfyUI-mxToolkit'
git clone https://github.com/Smirnov75/ComfyUI-mxToolkit

echo 'Install CRT-Nodes'
git clone https://github.com/PGCRT/CRT-Nodes
pip install -r CRT-Nodes/requirements.txt

echo '____FINISHED____'
