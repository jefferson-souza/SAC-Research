#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_ADXL375.h>

#include <WiFi.h>
#include <WiFiUdp.h>


// Definir as credenciais de WiFi
const char* ssid = "jeff";
const char* password = "12345678";

// IP e porta do servidor Node.js
const char* udpAddress = "192.168.68.128"; // Altere para o IP do seu servidor
const int udpPort = 12345;

WiFiUDP udp;

// Tamanho do buffer (armazena 100 leituras antes de enviar)
//const int BUFFER_SIZE = 230;
const int BUFFER_SIZE = 1000;
int16_t buffer1[BUFFER_SIZE * 3];
int16_t buffer2[BUFFER_SIZE * 3];
int16_t *activeBuffer = buffer1;  // Buffer ativo para gravação
int16_t *sendingBuffer = buffer2;  // Buffer para envio
int bufferIndex = 0;

// Objeto do acelerômetro
Adafruit_ADXL375 accel = Adafruit_ADXL375(12345); // O parâmetro é um identificador exclusivo, pode ser qualquer número

// Mutex para garantir acesso exclusivo às variáveis compartilhadas
portMUX_TYPE mux = portMUX_INITIALIZER_UNLOCKED;

// Variáveis compartilhadas entre os núcleos
volatile float accelDataX = 0.0;
volatile float accelDataY = 0.0;
volatile float accelDataZ = 0.0;

volatile float avg_x1 = 0.0;
volatile float avg_y1 = 0.0;
volatile float avg_z1 = 0.0;

void task1(void *pvParameters) {
  (void)pvParameters;

  sensors_event_t event;

  while (1) {
    // Leitura dos dados do acelerômetro
    accel.getEvent(&event);

    // Aquisição do mutex para garantir acesso exclusivo às variáveis compartilhadas
    portENTER_CRITICAL(&mux);
    accelDataX = event.acceleration.x;
    accelDataY = event.acceleration.y;
    accelDataZ = event.acceleration.z;
    portEXIT_CRITICAL(&mux);

  }
}

void task2(void *pvParameters) {
  (void)pvParameters;
  //char cMsg[254];
  //line++;

  //zero_axis();
  while (1) {
    // Aquisição do mutex para garantir acesso exclusivo às variáveis compartilhadas
    portENTER_CRITICAL(&mux);
    
    //float x = (accelDataX - avg_x1)/9.8;
    //float y = (accelDataY - avg_y1)/9.8;
    //float z = (accelDataZ - avg_z1)/9.8;

    float x = accelDataX;
    float y = accelDataY;
    float z = accelDataZ;    
    portEXIT_CRITICAL(&mux);

    //sprintf(cMsg, "%0.2f;%0.2f;%0.2f", x, y, z );
    //Serial.println(cMsg);    

    // Armazenar os dados no buffer    
    activeBuffer[bufferIndex++] = (int16_t)(x * 100);
    activeBuffer[bufferIndex++] = (int16_t)(y * 100);
    activeBuffer[bufferIndex++] = (int16_t)(z * 100);

    if (bufferIndex >= BUFFER_SIZE * 3) {
      // Mudar buffers
      memcpy(sendingBuffer, activeBuffer, BUFFER_SIZE * 6);
      bufferIndex = 0;
      activeBuffer = (activeBuffer == buffer1) ? buffer2 : buffer1;
      
      // Enviar dados via UDP
      udp.beginPacket(udpAddress, udpPort);
      udp.write((uint8_t*)sendingBuffer, BUFFER_SIZE * 6);
      udp.endPacket();
    }   
    delayMicroseconds(160); 

  }
}


void setup() {
  Serial.begin(115200);
  //Serial.begin(230400);
 
  while (!Serial);
  Serial.println("ADXL375 Accelerometer Test"); Serial.println("");

   // Conectar ao WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.println(password );
    Serial.println(ssid );
    delay(1000);
    Serial.println("Conectando ao WiFi...");
  }
  Serial.println("Conectado ao WiFi");

  // Inicialização do acelerômetro
  if (!accel.begin()) {
    Serial.println("Falha ao iniciar o ADXL375!");
    while (1);
  }

  delay(500); 
  //accel.setRange(ADXL345_RANGE_16_G);
  //accel.setDataRate(ADXL345_DATARATE_3200_HZ);
  displaySensorDetails();
  
  delay(500); 
  // Criação das tasks
  xTaskCreatePinnedToCore(task1, "Task1", 10000, NULL, 1, NULL, 0); // Task 1 no núcleo 0
  xTaskCreatePinnedToCore(task2, "Task2", 10000, NULL, 1, NULL, 1); // Task 2 no núcleo 1
}


// Função para enviar o conteúdo do arquivo pela Serial
void sendData() {
      // Enviar dados via UDP
      udp.beginPacket(udpAddress, udpPort);
      udp.write((uint8_t*)sendingBuffer, BUFFER_SIZE * 6);
      udp.endPacket();
}

void displaySensorDetails(void)
{
  sensor_t sensor;
  accel.getSensor(&sensor);
  Serial.println("------------------------------------");
  Serial.print  ("Sensor:       "); Serial.println(sensor.name);
  Serial.print  ("Driver Ver:   "); Serial.println(sensor.version);
  Serial.print  ("Unique ID:    "); Serial.println(sensor.sensor_id);
  Serial.print  ("Max Value:    "); Serial.print(sensor.max_value); Serial.println(" m/s^2");
  Serial.print  ("Min Value:    "); Serial.print(sensor.min_value); Serial.println(" m/s^2");
  Serial.print  ("Resolution:   "); Serial.print(sensor.resolution); Serial.println(" m/s^2"); 
  Serial.println("------------------------------------");
  Serial.println("");
  delay(500);
}

float average (float * array, int len)  // assuming array is int.
{
  double sum = 0L ;  // sum will be larger than an item, long for safety.
  for (int i = 0 ; i < len ; i++)
    sum += array [i] ;
  return  ((float) sum) / len ;  // average will be fractional, so float may be appropriate.
}

void zero_axis(){

  float array_data[2000];

  int len = sizeof(array_data) / sizeof(float);

  for(int i=0; i<len; i++){
    portENTER_CRITICAL(&mux);
    array_data[i] = accelDataX;
    portEXIT_CRITICAL(&mux);

    delayMicroseconds(160);
  }
  avg_x1 = average(array_data, len);

  for(int i=0; i<len; i++){
    portENTER_CRITICAL(&mux);
    array_data[i] = accelDataY;
    portEXIT_CRITICAL(&mux);

    delayMicroseconds(160);
  }
  avg_y1 = average(array_data, len);

  for(int i=0; i<len; i++){
    portENTER_CRITICAL(&mux);
    array_data[i] = accelDataZ;
    portEXIT_CRITICAL(&mux);

    delayMicroseconds(160);
  }
  avg_z1 = average(array_data, len);

}

void loop() {
  // O loop principal é deixado vazio, já que as tasks estão sendo executadas nos núcleos separados
}