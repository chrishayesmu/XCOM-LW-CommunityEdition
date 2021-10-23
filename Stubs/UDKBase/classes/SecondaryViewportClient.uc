/**
 * Example 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SecondaryViewportClient extends ScriptViewportClient
	native;

cpptext
{
	virtual void Draw(FViewport* Viewport,FCanvas* Canvas)
	{
		// clear the screen
		ENQUEUE_UNIQUE_RENDER_COMMAND(
			SecondaryViewportClientClear,
		{
			RHIClear(TRUE, FLinearColor::Black, FALSE, 0.0f, FALSE, 0);
		});

		UCanvas* CanvasObject = FindObject<UCanvas>(UObject::GetTransientPackage(),TEXT("CanvasObject"));
		if( !CanvasObject )
		{
			CanvasObject = ConstructObject<UCanvas>(UCanvas::StaticClass(),UObject::GetTransientPackage(),TEXT("CanvasObject"));
			CanvasObject->AddToRoot();
		}
		CanvasObject->Canvas = Canvas;	

		// Reset the canvas for rendering to the full viewport.
		CanvasObject->Init();
		CanvasObject->SizeX = Viewport->GetSizeX();
		CanvasObject->SizeY = Viewport->GetSizeY();
		CanvasObject->SceneView = NULL;
		CanvasObject->Update();		

		//ensure canvas has been flushed before rendering UI
		Canvas->Flush();

		// let script code render something
		eventPostRender(CanvasObject);
	}
	virtual UBOOL RequiresHitProxyStorage() { return 0; }
}

/**
 * Called after rendering the player views and HUDs to render menus, the console, etc.
 * This is the last rendering cal in the render loop
 * @param Canvas - The canvas to use for rendering.
 */
event PostRender(Canvas Canvas)
{
	local PlayerController PC;
	local MobilePlayerInput MPI;
	local MobileHUD MH;

	// boost the HUD from main screen, for now
	foreach class'Engine'.static.GetCurrentWorldInfo().LocalPlayerControllers(class'PlayerController', PC)
	{
		MPI = MobilePlayerInput(PC.PlayerInput);
		if( MPI != none )
		{
			MH = MobileHUD(PC.myHUD);
			if( MH != none )
			{
				MH.Canvas = Canvas;
				MH.DrawInputZoneOverlays();
				MH.RenderMobileMenu();
				break;
			}
		}
	}
}

defaultproperties
{

}
