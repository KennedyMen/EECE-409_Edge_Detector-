module tb_Non_Max_Suppresion;

    // Parameters
    parameter IMG_WIDTH = 512;
    parameter IMG_HEIGHT = 512;
    parameter WINDOW_SIZE = 3;
  
    // Inputs
    logic signed [10:0] Gradiant_Magnitude_Pixel;
    logic signed [1:0] Direction_Pixel;
  
    // Outputs
    logic signed [10:0] processed_pixels [0:11];
  
    // Instantiate the Unit Under Test (UUT)
    Non_Max_Suppresion uut (
      .Gradiant_Magnitude_Pixel(Gradiant_Magnitude_Pixel),
      .Direction_Pixel(Direction_Pixel),
      .processed_pixels(processed_pixels)
    );
  
    // Test images
    logic signed [10:0] image_magnitude [0:IMG_HEIGHT-1][0:IMG_WIDTH-1];
    logic signed [1:0] image_direction [0:IMG_HEIGHT-1][0:IMG_WIDTH-1];
  
    // Task to read image from file
    task read_image_from_file_magnitude;
      input string path;
      int file;
      int byte_data;
      int i, j;
      begin
        // Open the file for reading
        file = $fopen(path, "rb");
        if (file == 0) begin
          $error("ERROR: Could not open the text file.");
          $finish;
        end
  
        // Read the file byte by byte and store in image array
        for (i = 0; i < IMG_HEIGHT; i++) begin
          for (j = 0; j < IMG_WIDTH; j++) begin
            byte_data = $fgetc(file);
            if (byte_data == -1) begin
              $error("ERROR: Unexpected end of file.");
              $finish;
            end
            image_magnitude[i][j] = byte_data;
          end
        end
  
        // Close the file
        $fclose(file);
      end
    endtask
  
    task read_image_from_file_direction;
      input string path;
      int file;
      int byte_data;
      int i, j;
      begin
        // Open the file for reading
        file = $fopen(path, "rb");
        if (file == 0) begin
          $error("ERROR: Could not open the text file.");
          $finish;
        end
  
        // Read the file byte by byte and store in image array
        for (i = 0; i < IMG_HEIGHT; i++) begin
          for (j = 0; j < IMG_WIDTH; j++) begin
            byte_data = $fgetc(file);
            if (byte_data == -1) begin
              $error("ERROR: Unexpected end of file.");
              $finish;
            end
            image_direction[i][j] = byte_data;
          end
        end
  
        // Close the file
        $fclose(file);
      end
    endtask
  
    initial begin
      // Initialize Inputs
      Direction_Pixel = 2'b00;
  
      // Read images from files
      read_image_from_file_magnitude("/home/deck/Desktop/edge_runners/testImages/output_binary/gradient_magnitude.txt");
      read_image_from_file_direction("/home/deck/Desktop/edge_runners/testImages/output_binary/gradient_direction.txt");
  
      // Process the image in a sliding window manner
      for (int row = 0; row <= IMG_HEIGHT - WINDOW_SIZE; row++) begin
        for (int col = 0; col <= IMG_WIDTH - WINDOW_SIZE; col++) begin
          // Pass the 3x4 window values to the module
          for (int i = 0; i < WINDOW_SIZE; i++) begin
            for (int j = 0; j < WINDOW_SIZE; j++) begin
              Gradiant_Magnitude_Pixel = image_magnitude[row + i][col + j];
              Direction_Pixel = image_direction[row + i][col + j];
              #10; // Wait for 10 time units
            end
          end
  
          // Display the processed pixels
          $display("Processed Pixels for window starting at (%0d, %0d):", row, col);
          for (int i = 0; i < 12; i++) begin
            $display("%d: %d", i, processed_pixels[i]);
          end
        end
      end
  
      $finish;
    end
  
  endmodule