import toxi.processing.*;

public final float EPSILON = 0.00001f;
public PApplet PAPPLET = this;
public ToxiclibsSupport gfx;
public PGraphics render;

public Tree tree;

public final float
	MUTATION_RATE = 0.6f,
	MUTATION_AMP = 0.5f;

public boolean
	D_PATH = false,
	D_WIREFRAME = false,
	D_NORMAL = false,
	D_TEX = true,
	D_BGWHITE = true;


public Population population;
public PImage TEX;

void settings(){
	size(displayWidth-100, int(displayWidth/2), OPENGL);
	// fullScreen(OPENGL);
}

void setup(){
	gfx = new ToxiclibsSupport(this);

	TEX = loadImage("data/grid.jpg");
	textureMode(NORMAL);

	population = new Population(5, MUTATION_RATE, MUTATION_AMP);
	//tree = new Tree(this, population);
}

void draw(){
	surface.setTitle(int(frameRate) + "fps");
	background(int(D_BGWHITE)*255);

	ambientLight(127, 127, 127);
	directionalLight(127, 127, 127, 0, 1, 1);

	translate(scene_offset.x, scene_offset.y);
	pushMatrix();
		translate(0, height/2, -zoom_out*2);
		population.display(-width, width*2);
	popMatrix();

	fill(0);
	textAlign(CENTER, BOTTOM);
	textSize(24);
	text(population.getSelected().getName() + " : " + population.getSelected().getMaterial().getStr(), int(width/2), height-30);

	textSize(16);
	textAlign(LEFT, BOTTOM);
	text(population.getGeneration(), 30, height-30);
}

void keyPressed(){
	if(key == 'r'){
		population = new Population(population.getOrganisms().length, population.getMutationRate(), population.getMutationAmp());
		if(tree!=null) tree.reset();
	}
	if(key == 'p') D_PATH = !D_PATH;
	if(key == 'n') D_NORMAL = !D_NORMAL;
	if(key == 't') D_TEX = !D_TEX;
	if(key == 'w') D_WIREFRAME = !D_WIREFRAME;
	if(key == 'c') D_BGWHITE = !D_BGWHITE;
	if(key == 'e') population.getSelected().export(30);
	if(key == ' ' || key =='s'){
		// population.export(sketchPath("export/"), 30);
		Organism s = population.getSelected();
		if(tree!=null) tree.add(s);
		population.reproduce(s);
	}
}

float zoom_out = 1500;
Vec2D scene_offset = new Vec2D();
void mouseWheel(MouseEvent event){ zoom_out += event.getCount(); }
void mouseDragged(){
	scene_offset.x += mouseX - pmouseX;
	scene_offset.y += mouseY - pmouseY;
}