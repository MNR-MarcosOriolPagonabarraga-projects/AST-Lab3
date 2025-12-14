/*
 * Function: ReferenceGenerator
 *  Generates a reference trajectory and send it to the actuator.
 *    
 * Inputs: 
 *  - running_time (float): Current time instant of the system in seconds.
 *  
 * Outputs:
 *  - (float): Desired position in degrees.
 */
float ReferenceGenerator(float running_time) {
  const float amplitude = 20.0;          // degrees
  const float omega = 5.0;               // rad/s
  const float phase_offset = 45.0 * PI / 180.0;  // convert to radians

  // Generate sine wave (result in degrees)
  float angle = amplitude * sin(omega * running_time + phase_offset);

  return angle; // in degrees
}
