#include <stdint.h>
#include <stdio.h>

#define K8 { 0x09B7, 0 };

typedef struct { int16_t x, y; } Vector;
uint8_t gamma[8] = { 127, 75, 40, 20, 10, 5, 3, 1 };

Vector Tp( Vector vector, int i ) {
		Vector out =  { vector.x - (vector.y >> i) , vector.y + (vector.x >> i) };
		return out;
}
Vector Tn( Vector vector, int i ) {
		Vector out =  { vector.x + (vector.y >> i) , vector.y - (vector.x >> i) };
		return out;
}

Vector rotate( uint8_t angle ) {
	Vector vector = K8;
	int16_t angle16 = angle;

	for ( int i = 0; i < 8; i++ ) {
		if ( angle16 > 0 ) {
			angle16 -= gamma[i];
			vector = Tp( vector, i );
		}
		else {
			angle16 += gamma[i];
			vector = Tn( vector, i );
		}

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
