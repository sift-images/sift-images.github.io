import java.util.*;

//input parameters:
int subSize = 20;
int depth = 6;  // depth is the size of transform matrix that is stored
int rows = 2;
int cols = 2;

//color rendering:

float[][] image = new float[depth*cols*3][depth*rows];

int pix;
int add = 40;
int mult = 2;


//dctIII; old matrix = T. computes x,y (variables are switched but it works)
public float[][] dct(float[][] input) {
    float[][] transform = new float[subSize][subSize];

    for (int u=0; u<subSize; u++) {
	for (int v=0; v<subSize; v++) {
	    float scale;

	    transform[u][v] = 0;
	    float hold = 0;
	    //x, y < subSize is full-strength (applies all basis images); 1,1 is min
	    for (int x=0; x<depth; x++) {
		for (int y=0; y<depth; y++) {
		    if (x == 0) {
			if (y == 0) {
			    scale = .5;
			}
			else {
			    scale = pow(2,-.5);
			}
		    }
		    else {
			if (y != 0) {
			    scale = 1;
			}
			else {
			    scale = pow(2,-.5);
			}
		    }
		    hold = cos((2*u+1)*x*PI/2/subSize)*cos((2*v+1)*y*PI/2/subSize)*scale*input[x][y]/4;
		    transform[u][v] += hold;
		}
	    }
	}
    }
    return transform;
}  

int padTop;
int padLeft;


void setup() {
    frameRate(20);
    size(400, 400);
    pix = height / rows / subSize;
    noStroke();
    for (int x=0;x<cols*depth*3;x++) {
	for (int y=0;y<rows*depth;y++) {
	    image[x][y] = int(random(-3,3));
	    //println("col,row = ",x,y);
	    //println(eights[x][y],x,y);
	}  
    }
    background(0);
}

void draw() {
    noStroke();
    
    //pull from image[0,0...depth] for R[O,O]
    //pull from image[0,1] for G , [o,2] for blue
    int flipX, flipY;
    int xShift, yShift;


    //these are metarows and cols
    for (int row=0;row<rows;row++) {
	if (row  == 0) {
	    flipY = 1;
	    yShift = width/2;
	} else {
	    flipY = -1;
	    yShift = width/2*(subSize-1)/subSize;
	}
	for (int col=0;col<cols;col++) {
	    if (col == 0) {
		flipX = -1;
		xShift = width/2*(subSize-1)/subSize;
	    } else {
		flipX = 1;
		xShift = col*pix*subSize;
	    }
	
	    
	    float tempBlockR[][] = new float[depth][depth];
	    float tempBlockG[][] = new float[depth][depth];
	    float tempBlockB[][] = new float[depth][depth];
	    float r[][] = new float[subSize][subSize];
	    float g[][] = new float[subSize][subSize];
	    float b[][] = new float[subSize][subSize];

      
	    for (int i=0;i<depth;i++) {
		for (int j=0;j<depth;j++) {
		    tempBlockR[i][j] = image[3*col*depth+i][row*depth+j];
		    //println("R= image[",3*col*depth+i,row*depth+j,"]= ",image[3*col*depth+i][row*depth+j]);
		    tempBlockG[i][j] = image[3*col*depth+i+depth][row*depth+j];
		    //println("G= image[",3*col*depth+i+depth,row*depth+j,"]= ",image[3*col*depth+i+depth][row*depth+j]);
		    tempBlockB[i][j] = image[3*col*depth+i+2*depth][row*depth+j];
		    //println("B= image[",3*col*depth+i+2*depth,row*depth+j,"]= ",image[3*col*depth+i+2*depth][row*depth+j]);
		}
	    }
	    
	    r = dct(tempBlockR);
	    //println("R=",r[0][0]);
	    g = dct(tempBlockG);
	    //println("G=",g[0][0]);  
	    b = dct(tempBlockB);
	    //println("B=",b[0][0]);
	    //println("R=",r[0][0]);
	    for (int i=0;i<subSize;i++) {
		for (int j=0;j<subSize;j++) {
		    //println("R",i,j,"=",r[i][j]);
		    //println("G",i,j,"=",g[i][j]);
		    //println("B",i,j,"=",b[i][j]);

		    fill(to_color(r[i][j]), to_color(g[i][j]), to_color(b[i][j]));
		    rect(i*pix*flipX+xShift,j*pix*flipY+yShift,pix,pix);
		}
	    }
	}
    }
    
    for (int x=0;x<depth*cols*3;x++) {
	for (int y=0;y<depth*rows;y++) {
	    image[x][y] = (image[x][y] + random(0,2)) % 38 - 1.05;
	    //println(x,y,"updated in image to: ",image[x][y]);
	}
    }
}

  
int to_color(float x) {
    return Math.max(Math.min(255, (x+add)*mult), 0)
	}
