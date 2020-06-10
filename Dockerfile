# Ubuntu 18.04 included below
#FROM tensorflow/tensorflow:1.14.0-gpu-py3
FROM tensorflow/tensorflow:2.1.0-gpu-py3-jupyter

##########################
# Install the Tensorflow Object Detection API from here
# https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/installation.md

# Install object detection api dependencies
RUN apt-get update
RUN apt-get install -y protobuf-compiler python-lxml git && \
    pip install Cython && \
    pip install contextlib2 && \
    pip install pycocotools

#RUN git clone --depth 1 https://github.com/tensorflow/models.git
#RUN tf_upgrade_v2 --intree models --outtree models_v2 --reportfile report.txt
#RUN cp -r models_v2 /home

# Run protoc on the object detection repo
#RUN cd /home/models_v2/research && \
    #protoc object_detection/protos/*.proto --python_out=.

# Set the PYTHONPATH to finish installing the API
#ENV PYTHONPATH $PYTHONPATH:/home/models_v2/research:/home/models/research/slim
################################

# Install gcloud utils
#RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
#RUN apt-get install -y apt-transport-https ca-certificates gnupg
#RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
#RUN apt-get update && apt-get install -y google-cloud-sdk

# others
RUN apt-get update
RUN apt-get -y install cmake 
RUN apt-get install -y libsm6 libxext6 libxrender-dev
RUN apt-get install libopencv-dev

# expose ports for jupyter notebooks and tensorboard
EXPOSE 8888
EXPOSE 6006

RUN mkdir /home/darknet
WORKDIR /home/darknet

# copy the current dir
COPY . .

# install the requirements.txt packages
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements-gpu.txt

# install the package
RUN pip install -e .

# add some jupyter configurations
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.allow_root = True" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py


CMD ["/bin/bash"]
