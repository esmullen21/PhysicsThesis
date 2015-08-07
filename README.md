# PhysicsThesis
This is the file that I wrote for my physics thesis entitled "Development of a Computer Program for the assessment of Colour Doppler Spatial Resolution and identification of suitable filament for its assessment."

Each filament was tested using different setting on the ultrasound machine. I have included five images of the 0.06mm filament using a setting of filter 0.

**Program operation - Taken from my Thesis**
1) The program prompts the user to select the folder containing the images. The folder must contain 5 images and must be numbered 1 to 5. It then prompts the user to select the first image and then the fifth image. This tells MATLAB that there are 5 images, numbered from 1 to 5.

2) The next section of the program deals with calibrating the images. A line must be fit over a know distance such as the depth line indicator on the right side of the image and the distance must be input in mm, in this case 160mm is input. This then determines a value for the number of millimetres per pixel. The user is then asked to select two points on the image, one above and one below the filament, in as straight a line as possible. This ensures that the same region is investigated for all the images in the batch. The calibration stage and the user required stage is now complete.

3) The program then enters a loop, which will analyse each of the images in the folder. First it reads the number of characters in the image’s file name and depending on if the images are numbered 1 to 5, decides whether to run it or not. For example, if image number 4 is missing, the program will run up until that point, but will display an error upon reaching that point.

4) The image is then split up into its different channels, red, green and blue. Each is analysed individually. The program gets the image profile from x to y, as seen for the red channel in figure 8. Assuming that each value of intensity corresponds to one pixel on the line, the number of elements in the array, called n. n was then multiplied by the value for millimetres per pixel, to get the length of the line, d. An array was then created from 0 to d in n increments. This gives the values for the x axis. 

5) Using the bioinformatics toolbox, the peak is identified, and the maximum value determined. The program then returns the x values at half maximum, the right hand one is subtracted from the left hand side one to give the Full Width Half Maximum. This is done for the Red, Green and Blue channels.

6) Finally, the program outputs the values saved in the arrays to an Excel file that is automatically generated in the image folder. The program outputs the Maximum value, each x value at each half maximum and Full Width at Half Maximum for each of the Red, Green and Blue channels.