#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>


typedef struct {
	int16_t sine;
	int16_t cosine;
} coords;

coords CORDIC( uint8_t target_angle, int iterations, uint8_t *gamma, int16_t *K ) {
	coords final = { 0, K[iterations] };
	coords temp;
	uint8_t accumulating_angle = 0;
	for ( int iteration = 0; iteration < iterations; iteration++ ) {

		temp = final;

		if (accumulating_angle < target_angle) {
			accumulating_angle += gamma[ iteration ];
			final.sine += temp.cosine >> iteration;
			final.cosine -= temp.sine >> iteration;

		}
		else {
			accumulating_angle -= gamma[ iteration ];
			final.sine -= temp.cosine >> iteration;
			final.cosine += temp.sine >> iteration;
		}


	}
	return final;
}

int main(int argc, char** argv) {
	uint8_t gamma[10];
	int16_t K[10];
	K[0] = 0xFFFF;
	for (int i = 0; i < 10; i++)  gamma[i] = (0xFF) *  atan( pow( 2, -i ) ) / (M_PI/2) ;
	for (int i = 1; i < 10; i++)  K[i] = K[i-1] / sqrt( 1 + pow(2, -2*i) );
	


	uint8_t angle = 0;
	coords rotated;
	printf("Angle\tSine(raw)\tSine(float)\tCosine(raw)\tCosine(float)\n");
	for (int i = 0; i < 18; i++) {
		angle += 0xFF * 5/90;
		rotated = CORDIC( angle, 6, gamma, K );
		printf("%d\t%d\t%f\t%d\t%f\n",
			 angle,
			 rotated.sine,
			 ( (float) rotated.sine ) / 0xFFFF,
			 rotated.cosine,
			 ( (float) rotated.cosine ) / 0xFFFF  
		 );
	}
}

