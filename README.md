# Configuring open3D in a docker image to render images

In this tutorial I'd like to simplify the life of someone who needs to use open3D's Headless mode, because during the configuration of the docker image I had some problems related to the use of the update_renderer method inside ubuntu OS. Based on this, we saw an opportunity to create this tutorial to help people who need to use open3d with python inside a docker image.

This tutorial will contain:
- A basic python code with open3d that demonstrates a manipulation of a point cloud;
- A dockerfile demonstrating the configuration of an ubuntu image to run the python code;
- and possible improvements that can be applied to the code.


## Requirements:
- Python 3.10 or higher
- Open3D
- Docker desktop

## Python code
```python
import open3d as o3d

if __name__ == "__main__":
    dataset = o3d.data.EaglePointCloud()

    pcd = o3d.io.read_point_cloud(dataset.path)

    R = pcd.get_rotation_matrix_from_xyz((1.1, -1.7, -2.0))
    pcd.rotate(R, center=(0, 0, 0))
    pcd.estimate_normals()   
    
    # o3d.visualization.draw_geometries([pcd])
    
    # This code creates a preview window and takes a screenshot of the image inserted in this window.
    vis = o3d.visualization.Visualizer()
    vis.create_window(window_name="Open3D Headless Window", visible=False)
    vis.add_geometry(pcd)
    vis.update_geometry(pcd)
    vis.poll_events()
    vis.update_renderer()
    vis.capture_screen_image('output/img.png', do_render=True) # The render_parameter is super important
    vis.destroy_window()
```

## Docker configuration
```docker
FROM ubuntu:22.04

RUN apt-get update && \ 
    apt install -y xvfb python3.10 python3-pip curl && \
    apt-get install --no-install-recommends -y \
    libegl1 \
    libgl1 \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://archive.ubuntu.com/ubuntu focal main universe" > /etc/apt/sources.list

RUN apt-get update && \ 
    apt-get install -y --no-install-recommends libgl1-mesa-glx \
    libgl1-mesa-dri \
    libllvm10 \
    libpq-dev # These are the dependencies needed to run open3D using Mesa drivers

# reference: https://www.open3d.org/docs/release/docker.html#

# from this point you can configure as you see fit, as the most important settings have already been made
WORKDIR /src

```