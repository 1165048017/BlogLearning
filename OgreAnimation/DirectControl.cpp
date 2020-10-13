#include <iostream>
#include "Ogre.h"
#include "OgreApplicationContext.h"
using namespace Ogre;
using namespace OgreBites;

class MyTestApp : public ApplicationContext, public InputListener
{
public:
	Entity *ent,*ent1,*ent2;
	Animation *anim;
	AnimationState *as;
	Bone *lshoulder, *lknee;
	SkeletonInstance *skel, *skel2;
	Ogre::NodeAnimationTrack *tracksnew;
	Quaternion prev_rotate=Quaternion::IDENTITY;
    MyTestApp();
    void setup();
    bool keyPressed(const KeyboardEvent& evt);
    bool frameRenderingQueued(const FrameEvent &evt);
	void createAnim();
};

//! [constructor]
MyTestApp::MyTestApp() : ApplicationContext("OgreTutorialApp")
{
}
//! [constructor]

//! [key_handler]
bool MyTestApp::keyPressed(const KeyboardEvent& evt)
{
    if (evt.keysym.sym == SDLK_ESCAPE)
    {
        getRoot()->queueEndRendering();
    }
    return true;
}
//! [key_handler]

//! [setup]
void MyTestApp::setup(void)
{
    // do not forget to call the base first
    ApplicationContext::setup();
    
    // register for input events
    addInputListener(this);

    // get a pointer to the already created root
    Root* root = getRoot();
    SceneManager* scnMgr = root->createSceneManager();

    // register our scene with the RTSS
    RTShader::ShaderGenerator* shadergen = RTShader::ShaderGenerator::getSingletonPtr();
    shadergen->addSceneManager(scnMgr);

    // without light we would just get a black screen
    Light* light = scnMgr->createLight("MainLight");
    SceneNode* lightNode = scnMgr->getRootSceneNode()->createChildSceneNode();
    lightNode->setPosition(0, 10, 15);
    lightNode->attachObject(light);

    // also need to tell where we are
    SceneNode* camNode = scnMgr->getRootSceneNode()->createChildSceneNode();
    camNode->setPosition(0, 0, 30);
    camNode->lookAt(Ogre::Vector3(0, 0, -1), Node::TS_PARENT);

    // create the camera
    Camera* cam = scnMgr->createCamera("myCam");
    cam->setNearClipDistance(5); // specific to this sample
    cam->setAutoAspectRatio(true);
    camNode->attachObject(cam);

    // and tell it to render into the main window
    getRenderWindow()->addViewport(cam);

    // finally something to render
    ent = scnMgr->createEntity("Sinbad.mesh");
    SceneNode* node = scnMgr->getRootSceneNode()->createChildSceneNode();
    node->attachObject(ent);

	ent1 = scnMgr->createEntity("jaiqua.mesh");
	ent2 = scnMgr->createEntity("Sinbad.mesh");
	SceneNode* node1 = node->createChildSceneNode();
	node1->setPosition(10, 0, 0);
	SceneNode* node2 = node->createChildSceneNode();
	node2->setPosition(-10, 0, 0);
	node1->attachObject(ent1);
	node2->attachObject(ent2);

	skel = ent->getSkeleton();
	lshoulder = skel->getBone("Humerus.L"); lshoulder->setManuallyControlled(true);
	lknee = skel->getBone("Calf.L"); lknee->setManuallyControlled(true);
	skel2 = ent2->getSkeleton();

	for (int j = 0; j < skel->getNumBones(); j++) {
		skel->getBone(j)->setManuallyControlled(true);
		skel2->getBone(j)->setManuallyControlled(true);
	}
}
//! [setup]

// frame rendering
int i = 0;
bool MyTestApp::frameRenderingQueued(const FrameEvent &evt){   
	i++;
	Quaternion quat;
	quat.FromAngleAxis(Degree(i%2? 0.0f: -90.0f), Vector3::UNIT_X);
	
	lknee->setOrientation(quat);
	//lknee->needUpdate(true);
	for (int j = 0; j < skel->getNumBones(); j++) {		
		std::cout << skel->getBone(j)->getName() << std::endl;
		std::cout << skel2->getBone(j)->getName() << std::endl;

		skel2->getBone(j)->setOrientation(skel->getBone(j)->getOrientation());
		//skel2->getBone(j)->needUpdate(true);
	}
	
    return true;
}

//! [main]
int main(int argc, char *argv[])
{
    MyTestApp app;
    app.initApp();
    app.getRoot()->startRendering();
    app.closeApp();
    return 0;
}
//! [main]
