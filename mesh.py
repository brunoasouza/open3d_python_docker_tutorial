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
