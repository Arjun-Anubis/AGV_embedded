#include <stdint.h>
#include <stdio.h>

#define K8 0x09B7

typedef struct { int16_t x, y; } Vector;

Vector rotate( uint8_t angle ) {
	Vector vector = { K8, 0 };
	int16_t temp;
	int16_t angle16 = angle;

	uint8_t gamma[8] = { 127, 75, 40, 20, 10, 5, 3, 1 };

	int sign = 0;
	for ( int i = 0; i < 8; i++ ) {
		sign = angle16 < 0 ? 1 : -1;
		angle16 += sign * gamma[i];

		temp = vector.y;
		vector.y -= sign * (vector.x >> i) ;
		vector.x += sign * (temp >> i) ;

	}
	return vector;
}

int main() {
	float angle, sine;
	Vector vector;


	printf( "Angle(MU)\tAngle(deg)\t\tsin(mu)\t\tsin(decimal)\n" );


	for ( uint16_t i = 0; i < 256; i+=32 ) {
		angle = ( ( float ) 90 ) * i / 0xFF;
		vector = rotate( i );
		sine = (float) vector.y / 0x0FFF;
		printf( "%d\t\t%f\t\t%d\t\t%f\n", i, angle, vector.y, sine );
	}
}
