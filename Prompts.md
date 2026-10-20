Amber — hyperkinetic demo

    Parallel page transitions for React Router v8 on a shared GSAP timeline.

cover

Live demo ↗

The demo is Amber Genetics, a fictional lab archive with a React Three Fiber scene.

Page transitions use Hyperkinetic, a React Router library for parallel page transitions on a shared GSAP timeline.

Read the Codrops tutorial to learn how the transitions were built.
Stack

    React Router v8 (SPA + prerender)
    GSAP
    React Three Fiber
    Tailwind v4
    TypeScript
    Vite

Getting started

pnpm install
pnpm dev

Other scripts: pnpm build, pnpm start, pnpm typecheck, pnpm lint, pnpm format.

by isma.
About

Parallel page transitions with React Router and a single GSAP timeline
amber.isma.uy/
Resources
Readme
Activity
Stars
7 stars
Watchers
0 watching
Forks
3 forks
Report repository
Releases
No releases published
Contributors
1 (1)

    @ismamz
    ismamzIsmael Martínez

Languages

    TypeScript97.7%CSS2.3%

Footer
© 2026 GitHub, Inc.
Footer navigation

    Terms
# Elemental Sandbox

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#elemental-sandbox)

A skillshot VFX sandbox built with **Three.js**, **Vite** and hand-written **GLSL**.

[![Nova Beam mid-burn, with the HUD's ability bar, live stats and contact card](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/hud.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/hud.jpg)

Six abilities and two ways to aim them. Four are **line casts**: press the key to arm, a League-of-Legends style arrow appears on the ground and swings with the mouse, click to fire. The other two are **far casts**: the arrow is replaced by a circle with a deliberately thick boundary that follows the cursor and answers the only question a ground-targeted AoE has to answer before you commit — how much space is this going to take.

[![The line-cast aim arrow on the ground](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/aim-arrow.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/aim-arrow.jpg) [![The far-cast targeting circle and reach ring](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/aim-circle.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/aim-circle.jpg)

**Q — Frost Lance.** A fracture front races out along the line while a field of ice crystals tears up out of the floor behind it — small and dense at your feet, opening into a wall of blades at the far end, with a cluster thrown up around the impact point.

[![Frost Lance: a field of ice crystals erupting along the cast line](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/frost-lance.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/frost-lance.jpg)

**E — Storm Lance.** A bolt leaves the caster's hand and a bundle of lightning filaments is drawn out behind the strike front, holds while it gutters and re-strikes, then blows out. Sparks come off it the whole way, the floor underneath takes a branching electric burn and a dark scorch, and the far end gets a shell of ionised air.

[![Storm Lance: a bundle of lightning filaments with the ionised shell at the far end](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/storm-lance.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/storm-lance.jpg)

**R — Cinder Fall.** A burning rock is lobbed downrange on an arc, trailing a raymarched wake of burning gas and heating up the whole way: the lava seams splitting its surface prise wider and brighter as it comes in. It detonates on arrival, throws its own shattered chunks across the floor, and tears the ground open into a network of molten cracks that keep glowing while the crater burns out.

[![Cinder Fall: the burning rock in flight, trailing fire](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/cinder-fall.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/cinder-fall.jpg) [![Cinder Fall: molten cracks and flying wreckage after the detonation](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/cinder-fall-impact.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/cinder-fall-impact.jpg)

**F — Nova Beam.** The caster winds a ball of light up in both hands, pulling motes in out of the air, then lets a column of it out along the line — white-hot core, cyan sheath, gold ribbons spiralling around it and shock discs racing down it. It _holds_ there, burning into the floor and throwing spray back up the beam, before collapsing to a thread and blinking out. The only cast in the sandbox that is still happening a second after it landed.

[![Nova Beam: the orb winding up in the caster's hands](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/nova-beam-charge.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/nova-beam-charge.jpg) [![Nova Beam: the column burning, with gold coils and shock discs](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/nova-beam.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/nova-beam.jpg)

**V — Voltaic Snare.** The far cast. A leash of current is whipped out across the floor, and where it lands the ring snaps open past its own radius and pulls back onto it: a violet column tears up out of the middle, tendrils crawl outward to the boundary, arcs run around the rim and the whole disc burns. It holds there re-striking and hauling the air up into the pillar, then collapses to a thread. The circle you measured out before the click is exactly the circle you get.

[![Voltaic Snare: the ring snapping open as the column tears up](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/voltaic-snare-snap.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/voltaic-snare-snap.jpg) [![Voltaic Snare: the violet column, tendrils and burning disc holding](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/voltaic-snare.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/voltaic-snare.jpg)

**X — Glacial Crown.** The second far cast, and the snare's opposite answer to the same circle. A cold front races across the floor to the point, the disc freezes out to the boundary, and a ring of crystal blades tears up out of the ground around it — the blade nearest the caster first, the wave running round both sides to close behind — with a skirt of wreckage banked against their feet. The middle stays open: the read is a wall you are looking into. It stands there glinting and breathing cold off its rim, then shatters plate by plate and sinks back into the floor.

[![Glacial Crown: a ring of ice blades standing around a frozen disc](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/glacial-crown.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/glacial-crown.jpg)

Everything you can see is generated. There are no textures, no sprite sheets and no meshes on disk except the character: the crystals are procedural geometry, the bolt is a strip of ribbon placed entirely by a vertex shader, the meteor is an icosphere cratered and sliced by fracture planes on the CPU, the beam is a parametric tube drawn three times at three radii, the snare's whole cage is that same ribbon strip threaded along four different parametric paths, the arrow, the targeting circle, the rime, the burns and the molten cracks are signed-distance and noise shaders, and the mist, sparks, chips and glitter are GPU particles.

**Every parameter is a live slider** — 938 of them — and they stay live while the simulation is paused. That is the point of the project: freeze a frame mid-eruption, mid-strike or mid-burn with **P**, then reshape the silhouette, the palette and the timing against a still image.

References for the look: `icecast.jpg`, `thundercast.jpg`, `superbeam.jpg` and `electricalboost.jpg`.

---

## Quick start

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#quick-start)

```shell
npm install
```

```shell
npm run dev
```

Then open the URL Vite prints (default [http://127.0.0.1:5173](http://127.0.0.1:5173)).

```shell
npm run build
```

```shell
npm run preview
```

### Assets

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#assets)

Six binary assets are served from `public/` and loaded automatically at boot:

|File|Purpose|
|---|---|
|`public/models/Idle.fbx`|Rigged character **and** its idle animation clip|
|`public/models/diffuse.png`|The character's colour map|
|`public/models/cast1.fbx`|Cast animation|
|`public/models/cast2.fbx`|Cast animation|
|`public/models/cast3.fbx`|Cast animation — the default for Frost Lance, Root Snare and Glacier Crown|
|`public/hdri/spruit_sunrise.hdr`|HDR probe used for image-based lighting and crystal reflections|

All four FBX files are Mixamo exports of the same rig, each carrying a skinned mesh plus one animation stack. The character comes from the idle file; the cast files are loaded for their clip alone, and the duplicate rig that arrives with each one is released the moment its `AnimationClip` has been taken. Clips bind to the skeleton by bone name, which is the whole reason an animation authored in another file plays here without retargeting.

The rig ships no material, so `diffuse.png` is loaded beside it and assigned as the colour map when the imported materials are converted to PBR — an FBX that _does_ carry an embedded texture keeps its own, since that map is authored against its own UVs.

Every ability picks the clip it throws — `castAnim` in its settings block, a dropdown under **The cast** in its editor folder. Out of the box slots 1, 5 and 6 — Frost Lance, Root Snare and Glacier Crown — throw `cast3`, and the other three throw `cast1`. The clip is a one-shot laid over the looping idle, with `character.castBlendIn` / `castBlendOut` as the two edges of that overlap.

The HDR is loaded as image-based lighting and as the reflection source for the ice — it is never shown as a visible sky. The stage keeps its flat dark backdrop.

---

## Controls

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#controls)

|Input|Action|
|---|---|
|**Q** (or **1**)|Arm Frost Lance — press again to put it away|
|**E** (or **2**)|Arm Storm Lance — press again to put it away|
|**R** (or **3**)|Arm Cinder Fall — press again to put it away|
|**F** (or **4**)|Arm Nova Beam — press again to put it away|
|**V** (or **5**)|Arm Voltaic Snare — a far cast, aimed with a circle|
|**X** (or **6**)|Arm Glacial Crown — a far cast, aimed with a circle|
|**Move the mouse**|Swing the aim arrow, or move the far-cast circle|
|**Left click**|Cast along the arrow, or drop the circle where it is|
|**Esc** / **right click**|Cancel an armed cast|
|**Right mouse + drag**|Orbit the camera|
|**Scroll**|Zoom|
|**G**|Show/hide the VFX editor|
|**P**|Pause / resume — _the editor keeps applying_|
|**C**|Clear all active effects|
|**H**|Hide the controls panel|

`range` and `minRange` are per ability, so the indicator's reach changes with the slot you have selected. Aiming closer than the selected ability's `minRange` tints it red and refuses the cast; set `minRange` to 0 if you would rather cast at your own feet, which is what the Snare ships with — a trap you cannot drop on yourself is missing half its uses. Cooldowns are per ability too, so spending one slot never locks the other out.

---

## Project layout

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#project-layout)

```
src/
  abilities/      Ability base class (the travelling front), IceAbility, ThunderAbility,
                  MeteorAbility, BeamAbility, SnareAbility, pooling manager
  animation/      FBX character loading, AnimationMixer, the per-ability cast clips,
                  the procedural cast lunge
  assets/         Procedural crystal and asteroid geometry, the bolt ribbon strip,
                  the beam tube and its shock discs
  config/         settings.js — the single source of truth for every parameter
  core/           App, Renderer, CameraRig, Time, Layers, shared frame uniforms
  effects/        Aim arrow, far-cast circle, ground decals, fissures, bursts,
                  light pool, shake, flash
  input/          InputManager (events) and AimController (both targeting shapes)
  loaders/        AssetLoader with a shared LoadingManager
  materials/      IceMaterial, LightningMaterial, MeteorMaterial,
                  VolumetricFireMaterial, BeamMaterial, SnareMaterial
  particles/      GPU particle system + engine and rate emitters
  postprocessing/ Composer pipeline, grade shader, distortion shader
  shaders/lib/    Shared GLSL: noise library, common helpers
  ui/             HUD, lil-gui editor, preset manager, styles
  utils/          Maths, colour cache, pooling, disposal, shader patching
  world/          Environment (stage lighting), floor, dust, contact shadows
  archive/        The retired four-element sandbox — see archive/README.md
```

---

## How it fits together

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#how-it-fits-together)

### Settings are the API

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#settings-are-the-api)

`src/config/settings.js` holds every tweakable value. Nothing else owns that state: shaders, particle systems, lights and post passes _read_ those objects every frame. That is what makes the editor work with no rebuild — moving a slider changes the ice field that is already standing, the next cast, the environment and the post stack at once. Preset loading deep-merges _into_ the same objects so every live binding stays valid.

```js
import { settings } from './config/settings.js';
settings.ice.height = 7;          // visible on the next frame, even mid-cast
settings.thunder.jitter = 1.2;    // re-kinks a bolt that is already in the air
settings.global.timeScale = 0.1;  // slow the whole cast to a crawl
```

Ability blocks are keyed by their id in `ELEMENTS`, and the shared systems that need to know "which ability is the player holding" — the aim controller, the cooldowns, the HUD — look it up as `settings[element]`. The four fields they rely on being present are `range`, `minRange`, `speed` and `cooldown`; a far cast adds a fifth, `zoneRadius`. Everything else in a block is that ability's own business.

### The rule that makes "edit while paused" work

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#the-rule-that-makes-edit-while-paused-work)

A spike record in `IceAbility` stores **only what the dice decided**: a position _fraction_ along the line, a signed lateral _fraction_, and a handful of unitless jitters. Not one metre, radian or second is captured when the cast starts. Every dimension is resolved against `settings.ice` inside the update loop, which runs on a zero-length frame too.

So dragging `height` re-grows a field that is already standing; dragging `lean` re-tilts it; dragging `clumping` re-packs it toward the centre line. The only values a record _does_ capture are timestamps — the moment its own eruption was triggered. Those are events, not dimensions.

The four _shape_ controls (`facets`, `taper`, `roughness`, `bend`) cannot be expressed as a per-instance transform, so they are baked into the geometry instead — and a six-sided crystal is just 60 triangles, cheap enough to regenerate outright rather than approximate in a vertex shader. `IceAbility#_syncGeometry` hashes those four values and rebuilds the three crystal meshes when the hash changes, which is what keeps them live sliders rather than restart-required constants.

### Aiming

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#aiming)

`AimController` raycasts the pointer onto the ground plane **every frame**, not only on mouse move, so orbiting the camera with a cast armed swings the indicator under a stationary cursor. It clamps the distance into `[minRange, range]`, tracks a 0..1 reveal envelope, and emits a single `cast` event carrying an origin, a unit direction and a distance — which is exactly the signature `Ability#spawn` takes. It decides nothing about what the cast does.

It runs on **real** time rather than the scaled simulation delta, so the indicator keeps animating while the sandbox is paused.

There are two indicators and one controller. Which one is drawn comes from `ELEMENT_META[element].cast` — `CastShape.LINE` or `CastShape.ZONE` — and that is the _only_ thing the two shapes disagree about. Arming, clamping, validating, revealing and firing are shared, and both end in the same three-argument `cast` event, because from the targeting side a far cast is a line cast you only care about the far end of. That is why zone targeting needed no change in `Ability`, `AbilityManager` or `App`: `SnareAbility` reads its centre as `pointAt(1)` and works outward from there.

### The far-cast circle

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#the-far-cast-circle)

`ZoneIndicator` is the arrow's opposite number, and it is built out of the same two ideas: metres, and no textures.

The **footprint** is one quad whose fragment shader remaps UV into metres from the target, so the boundary stays 0.34 m thick whether the circle is 2 m or 8 m across. The band is deliberately the heaviest mark on screen — it is the whole message — and it is split about the nominal radius by `boundaryBias` rather than centred on it, so its _outer_ lip stays honest about where the effect ends. Inside there is a rim-weighted wash, contour rings travelling outward, warped filaments and a reticle whose downrange arm is longer, because the quad carries the caster's yaw and that arm is therefore the heading.

The **reach ring** at the caster is the bolt's ribbon strip bent into a circle: `(t, side)` in, world position out. A quad big enough to hold a 20 m range would be 40 m across and shade a screenful of discarded fragments for one thin line.

The circle **snaps out past its radius and settles back** when the cast is armed, and the trap does the same thing when it lands. A circle that grows linearly reads as a UI element; one that overshoots reads as something the caster did.

### The arrow is one SDF

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#the-arrow-is-one-sdf)

`AimIndicator` is a single ground quad. Its fragment shader remaps UV into **metres measured from the caster**, so every control in `settings.aim` is a real measurement — the shaft stays 0.42 m wide whether the cast is 3 m or 15 m long.

The silhouette is a rounded union of a box (the shaft) and iq's exact triangle SDF (the head); the cheap half-plane intersection leaves visible corner artefacts on a wedge this shallow. From that one distance field the shader derives the outline, the rim-weighted interior wash, the chevrons (a phase skewed by `|x|`, which turns flat bands into arrowheads pointing the way the cast does), the frost noise and voronoi plates, the ring at the caster's feet, the range cap arc, a six-fold frost rosette pinned to the impact point, and the sweep-out when the ability is armed.

### The ice

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#the-ice)

`materials/IceMaterial.js` patches a `MeshStandardMaterial` rather than replacing it, so the crystals cast and receive the stage's real shadows and pick up the HDR probe. The stylisation is injected on top:

- **Thickness tint** — a facet seen head-on has the longest path through the crystal, so it darkens toward `colorDeep`; grazing edges stay pale. This is the term that makes the field read as a solid you can see _into_ rather than as blue plastic.
- **Internal fracture** — ridged noise sampled in **world** space, so the crack planes stay a fixed physical size whether a spike is ankle-high or three metres tall, and neighbouring crystals look quarried from the same block.
- **Feather frost and rime** — fbm sampled in **local** space (0..1 up the crystal), so the milky veining and the frost creeping up from the base follow each spike's own axis however it is scaled or leaned.
- **Glint** — a hard-thresholded high-frequency field scrolling in world space, biased toward grazing angles, which is where real ice catches.
- **Birth flash** — a per-instance attribute the ability drives from 1 to 0 over `birthFade`, so a crystal is lit from within for the moment it erupts.

Three `InstancedMesh`es share one material. Three rather than one because the _facets_ differ, not just the proportions — per-instance scaling alone cannot buy that silhouette variety, and three draw calls is a cheap price.

### The lightning

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#the-lightning)

`ThunderAbility` takes the "no dimensions on the CPU" rule further than the ice does: there is no path object at all. The bolt is one `InstancedBufferGeometry` — a flat ladder of quads in _parameter_ space, where each vertex carries only `(t, side)`: how far along the bolt it is, and which edge of the ribbon it is on. One instance is one filament. `materials/LightningMaterial.js` turns that pair into a world position every frame, so a single strip serves a bolt of any length, any shape and any width.

Three things stack to make the shape:

- **the axis** — a straight line from the hand to the impact point, bowed by `sag`. The only part that knows where the cast is pointing.
- **the fan** — a constant per-filament offset in the plane perpendicular to the axis, opening from `spreadNear` at the hand to `spread` at the target and rolling around the axis with `twist`. This is what separates one filament from the next.
- **the kinks** — octaves of _linearly_ interpolated value noise. Linear on purpose: smoothstep would round the corners off, and the corners are the entire reason it reads as lightning rather than as a wobbly tube.

The ribbon is turned to face the camera by crossing the local tangent with the view vector, which is why the bolt keeps its apparent thickness from any angle without ever being a screen-space line. It is drawn twice — a wide soft halo underneath and the hot core on top — because drawing the glow as real ribbon rather than leaving it to bloom is what keeps it _attached_ to every kink.

Two clocks run the flicker. `restrike` snaps every filament onto a new shape N times a second, and `crawl` slides the kinks continuously in between; together they stop a held bolt from looking like a static ribbon. A cast captures exactly one number — a seed, so two casts do not draw the identical bolt — and resolves every metre, radian and second against `settings.thunder` each frame. That is why dragging `jitter` re-kinks a bolt that is already in the air.

The ground burns are worth a note as a thing _not_ to do. The first version sampled the filament field on `atan(y, x)`, which hands every radius along a given bearing the same value and draws dead-straight spokes out of the centre — a firework, not a burn. Sampling the same noise in the plane and warping the lookup is what lets the filaments meander and fork.

### The beam

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#the-beam)

The Nova Beam shares the bolt's rule — no dimensions on the CPU — and reaches the opposite look with it. Where the bolt's whole charm is that its noise is _piecewise-linear_ and keeps its corners, every noise term in the beam is smooth, stretched hard along the flow and crawling downrange. A beam that kinks is a bolt.

It is a real tube rather than a camera-facing ribbon, because a column this thick has to _have_ a cross-section: the silhouette must bow correctly when you orbit it, the far wall must add through the near one, and the shock discs have to hug it. `createBeamTubeGeometry` is the ribbon strip one dimension richer — every vertex carries `(t, a)`, how far along the barrel it is and how far around — and `materials/BeamMaterial.js` turns that pair into a world position each frame.

That one tube is drawn three times, and the trick is in how the three are weighted:

- **halo** — widest, nothing but a rim term. The atmosphere the beam is shoving out of the way.
- **sheath** — rim-weighted, so it reads as _hollow_ and its silhouette edges are its brightest part.
- **core** — narrow, and weighted the **opposite** way: brightest where the view ray runs down the barrel and its path through the tube is longest.

Rim-weighted outside, axis-weighted inside, both faces adding: that is a volume integral, cheaply, and the inversion is the entire reason the middle reads as a solid rod of light instead of as a lit pipe. Widen `coreWidth` or push `coreFill` up and the three layers collapse into one white tube — the cyan sheath and the gold coils are only legible because the core leaves them room.

Two more instanced passes put structure on it. The **coils** are the bolt's ribbon strip bent into a helix, camera-facing and warm on purpose — the colour split is what stops them dissolving into the sheath. The **shock discs** are an instanced annulus whose phase is `fract(index / count + time × speed)`, so the train is a pure function of the clock and there is no queue on the CPU. Both place themselves against the same `beamRadius()` the tube uses, which is why all five stay welded together when the profile is dragged.

The beam is also the one ability with a **fourth beat**. The other three run travel → impact → fade; this one puts a wind-up in front of that, and it needed nothing from the base class: `advance()` simply refuses to let the front leave the hand until the orb is up to power, so `IMPACT` becomes the burn and the phase machine is untouched. The far end therefore has an impact that keeps happening — spray thrown back up the line, pressure shells shed off the burning point, dust and shockwave rings pushed across the floor, all rate-throttled through the same fractional-rate emitter the particles use so every rate is a live slider.

### The snare

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#the-snare)

The Voltaic Snare is the first ability built around a _point_ instead of a line, and the thing that holds it together is that `zoneRadius` is read in exactly one place per consumer and nowhere is it copied: the indicator measures it out, the tendrils end on it, the rim arcs run along it, the field burns it and the column's throat and flare are fractions of it. Drag it and all five move together, mid-cast, with the clock stopped.

The whole cage — the whip that plants it, the pillar, the tendrils and the rim arcs — is **one instanced ribbon strip**, the same one the bolt and the beam's coils are drawn on. A filament's _role_ is decided in the vertex shader by testing its instance index against four live counts, and the role picks which parametric path it is threaded along:

- **leash** — a sagging line from the hand to the travelling tip, dropped onto the floor.
- **column** — a twisting climb whose radius opens from `throat` to `columnSpread`.
- **tendril** — a meander running outward, its veer a per-filament constant rather than noise, so it curves the way a discharge that has committed to a direction does.
- **rim** — an arc travelling around the boundary, hopping over it at mid-span.

Every offset then lives in a frame taken by finite difference off that path, which is what lets one kink function serve a vertical pillar and a filament crawling flat across the floor. The two ground-hugging roles damp the vertical component of that offset and clamp above the floor — a kink with a free `y` buries half of every tendril and the effect reads as a broken dotted line. Setting a count to zero retires the role outright, which is how the leash disappears on the frame the ring takes over. Two draw calls cover all four roles, however many filaments are in the air.

The **field** is a quad rather than a pooled decal for one reason: a decal captures its radius when it spawns, and this circle has to re-scale under `zoneRadius` while it is standing. Its veins are sampled in the plane and domain warped — the same lesson the bolt's ground burns taught, and for the same reason.

The one thing worth stealing for the next far cast is the **snap**: the ring opens on `Easing.outCubic` multiplied by a bump that peaks late and dies at exactly 1, so it overshoots its radius and pulls back onto it, and the pillar climbs on the same clock 1.7× slower. The ground goes first, then the air breaks down over it.

### Adding another ability

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#adding-another-ability)

1. Add a settings block in `config/settings.js` and an entry in `ELEMENTS` / `ELEMENT_META`.
2. Subclass `Ability` and implement `createShaders`, `createParticles`, `onTravel`, `onImpact`, `onFade`.
3. Register the class in `abilities/AbilityManager.js`.
4. Add an editor folder in `ui/Editor.js`, and a sigil in `ui/glyphs.js`.
5. Bind a key in `input/InputManager.js` — it emits `ability` with the 0-based slot index, which `App` maps through `ELEMENTS`.

To make it a **far cast** instead of a line cast, add two things and nothing else: `cast: CastShape.ZONE` in its `ELEMENT_META` entry, and a `zoneRadius` in its settings block. The circle indicator, the reach ring, the snap-out and the whole targeting loop come for free, and the ability reads its centre as `pointAt(1)`.

Everything else — pooling, the travelling front, the local frame, lights, phases, per-ability cooldowns, the aim reach and camera framing — is inherited or driven off `ELEMENTS`. The HUD builds its slots from that array, so a new ability appears in the bar on its own.

### Particles

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#particles)

`particles/ParticleSystem.js` is a GPU-simulated, instanced-quad system. Motion (velocity, gravity, analytic drag, curl turbulence, vortex swirl), size-over-lifetime, the colour gradient and alpha fade are all evaluated in the shader from per-instance attributes; the CPU only ever writes spawn data, and only the slots that changed are uploaded. Particles live in a ring buffer, so spamming the ability recycles slots instead of allocating. Silhouettes (soft, smoke, streak, leaf, chip, ring) are procedural — there are no sprite textures anywhere in the project.

Frost Lance uses three systems: **mist** (non-additive, so the fog genuinely occludes and gives the field depth), **shards** (lit chips under gravity) and **glitter** (additive, negative gravity — the rising plume that is the signature of the reference frame).

Storm Lance uses four: **sparks** (velocity-stretched streaks under gravity), **motes** (the slow ionised drift around the bolt), **smoke** (non-additive haze off the scorched floor) and **debris** (lit chips). Its sparks are emitted from several points along the bolt each frame rather than one: a beam sheds along its whole length, and a single origin makes every batch read as a starburst.

Nova Beam uses four as well, and works one of them twice: its **motes** are the intake spiralling _into_ the orb while it charges and the drift shed off the column once it is firing — the same glow, thrown the other way. Its **sparks** are thrown radially off the barrel and then dragged downrange by `sparkForward`, which is the read that says "pressure"; the bolt's fall instead, and that one difference does a lot of the work of keeping the two abilities apart.

### Render pipeline

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#render-pipeline)

Per frame:

1. **Depth prepass** — the opaque world into a half-res packed-depth buffer. Every VFX shader samples it for soft intersections, so nothing cuts a hard line into the ground. The crystals sit on `LAYER.WORLD`, so mist and glitter fade softly against them.
2. **Distortion pass** — meshes on the distortion layer write screen-space UV offsets into a second half-res buffer. Nothing writes to it in the current build; the pass is kept because it is the hook a refraction effect would use.
3. **Composer** — scene → refraction warp → bloom → tone map (ACES) → grade.

The grade pass folds chromatic aberration, lift/gain/contrast/saturation/temperature, vignette, film grain and the impact flash into one resample.

Shadows come from a single directional light whose orthographic shadow camera is re-centred on the character each frame and fitted to a 52 m box at 4096² (~1.3 cm/texel). The `three/addons` CSM module was tried first and removed: it replaces three's `lights_fragment_begin` chunk _globally_, so any material not explicitly registered with it silently loses all directional lighting.

Contact shadows are a real render: the character's depth is captured from below into a 256² target, blurred twice and projected onto the ground.

---

## Editor and presets

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#editor-and-presets)

Press **G** for the panel. Folders: Presets, Global, Aim indicator, Far-cast circle, Frost Lance, Storm Lance, Cinder Fall, Nova Beam, Voltaic Snare, Environment, Post processing, Camera, Character. Every folder starts collapsed — there are enough controls here that one open section pushes the rest off the screen.

[![The VFX editor open on Frost Lance's crystal and ice-material controls, with the sandbox paused mid-eruption](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/raw/main/docs/screenshots/editor.jpg)](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/blob/main/docs/screenshots/editor.jpg)

- **Global** multipliers scale everything at once (speed, glow, noise, particles, lights, impact intensity, camera shake, time scale…).
- **Aim indicator** — the arrow's silhouette in metres, its outline and fill, the chevrons and frost, and the rings and rosette.
- **Far-cast circle** (40 controls) — the boundary band, the interior, the ticks, sweep and reticle, the reach ring, and the snap-out. Shared by every far cast, so it is filed with the targeting rather than with any one ability.
- **Frost Lance** (113 controls, 25 of them colours) — the cast, the footprint, the silhouette, the crystal itself, the eruption timing, the ice material, the frost on the ground, mist/chips/glitter, the impact and the dynamic light.
- **Storm Lance** (123 controls, 34 of them colours) — the cast, where the bolt leaves the hand, the bundle, one filament, the ribbon, flicker and restrike, the bolt's colour, the burns on the ground, sparks/motes/smoke/debris, the muzzle and impact, and the dynamic light.
- **Nova Beam** (176 controls) — the cast, where it leaves the hands, the column, the core/sheath/ halo stack, the surface and its flow, the beam's colour, the coils, the shock discs, the charge and its intake, what the floor does, sparks/motes/steam/debris, release/impact/burn, and the two dynamic lights.
- **Voltaic Snare** (174 controls, 33 of them colours) — the cast and its footprint, the leash, the column, the tendrils, the rim arcs, the shared filament shape and flicker, the ribbon and its colour, the field on the floor, the burns, sparks/updraft/smoke/debris, throw/snap/hold, and the dynamic light.
- **Presets** save to `localStorage`, and can be duplicated, deleted, exported to JSON, imported from JSON, or reset to the shipped defaults.

Every ability exposes **every** colour it draws with, and none is derived from another: the crystal palette, the bolt palette, the beam's four layers and its coils and discs, the ground marks, the impact shells, the shockwave rings, the screen flashes, and a four-stop lifetime gradient (`birth → early → late → death`) for each particle system. Tinting the fog without touching the ice, or cooling the sparks to orange while the filaments stay blue, is a picker away.

Presets are plain snapshots of the settings tree, so an exported file is readable and editable by hand.

Knobs worth knowing about, because they reshape their ability the most:

- `ice.heightCurve` — how late the ramp climbs; raise it and the field stays low until it explodes at the target. `ice.frontBias` below 1 crowds the crystals toward the impact point.
- `thunder.jitter` and `thunder.jitterScale` — how violently the bolt kinks, and how often. `thunder.strands` and `thunder.spread` set how wide the bundle reads, and `thunder.restrike` how hard it strobes. Those five carry the character of the effect.
- `beam.radius` and `beam.flare` — how heavy the column reads and how hard it opens out where it lands. `beam.charge` and `beam.lifetime` are the wind-up and the hold, which are what make this ability feel unlike the other three, and `beam.coreWidth` / `beam.coreFill` decide whether the layers stay separable or blow out to white.
- `snare.zoneRadius` — the one number the whole far cast is built on. It resizes the targeting circle, the tendrils, the rim arcs, the burnt field and the pillar's throat together, live. After that, `snare.snapTime` and `snare.height` carry the moment it opens, and `snare.tendrils` / `snare.rimArcs` / `snare.strands` decide how much of that footprint is actually lit.
- `zone.boundary` and `zone.snap` — how thick the far-cast circle's edge reads, and how hard it overshoots on the way out. Between them they decide whether the indicator feels like a UI overlay or like something the caster is doing.

---

## Performance notes

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#performance-notes)

- Abilities, decals, bursts and particles are pooled, per type. Twelve casts in a row build at most **four** instances of an ability and then stop allocating.
- The whole crystal field is three draw calls regardless of crystal count; the cap is 288.
- A whole bolt is **two** draw calls regardless of filament count; the cap is 24 filaments at 72 samples each. Nothing about the path touches the CPU, so `strands` is nearly free.
- A whole snare — leash, pillar, tendrils and rim arcs — is **two** draw calls plus one for the field, regardless of how many filaments are in it; the cap is 56 across the four roles. As with the bolt, none of the shape touches the CPU, so raising `tendrils` or `rimArcs` is nearly free. Its targeting circle is two more: one quad and one ring strip.
- A whole beam is **six** draw calls regardless of how many coils and discs are on it — three tube passes over one shared geometry, plus one instanced draw each for the coils, the discs and the charge orb. As with the bolt, none of the shape touches the CPU, so `coils` and `rings` are nearly free. It takes two of the six dynamic lights (the column and the caster's hands), so four concurrent beams would exhaust the pool; `LightPool.acquire()` returns null and every use of the handle is guarded.
- The six dynamic point lights are created at boot and parked at zero intensity rather than added and removed — changing the light count forces three to recompile every material.
- Shadow maps update exactly once per frame even though the scene is rendered several times.
- `renderer.compileAsync()` runs during boot so the first cast never stutters on shader compile.
- Pixel ratio is capped at 1.75; the depth and distortion buffers are half resolution.

Measured on a default cast: 32 draw calls idle, ~69 with a full ice field standing and ~49 with a bolt in the air, ~1150 live particles. A snare standing with its cage, field and rim burns is ~45 draw calls and ~480 live particles, and arming its circle costs two. Four concurrent casts — the pool's ceiling, whichever slots they came from — peaks at ~186 draw calls and five of the six dynamic lights.

Live counters (FPS, live particles, instances, draw calls) are in the top-right of the HUD.

---

## The archive

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#the-archive)

`src/archive/` holds the previous incarnation of this project: a four-element bending sandbox (fire, water, earth, air) cast along a freehand-drawn spline, plus a walk mode that let the avatar ride the same stroke. None of it is imported by the live app, so Vite never bundles it.

It was retired because this build replaced path drawing with a linear skillshot, which removed the input every one of those systems was built on. The raymarched flame and water surfaces in particular are worth mining. See `src/archive/README.md` for what is in there and how to restore a piece of it.

---

## Known rough edges

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#known-rough-edges)

- Crystals are drawn with `transparent: true` and `depthWrite: true`. That is the right trade for near-opaque ice and it keeps the field from sorting through itself, but at low `ice.opacity` the sorting artefacts between overlapping spikes become visible.
- The eruption front is a straight line on a flat floor. Both assumptions are baked in — the ground is a single plane at y = 0, and the aim raycast targets that plane.
- The distortion pass runs with nothing writing to it. It costs a half-res clear per frame.
- The impact cluster is placed radially around the end point, so at very short cast distances it can overlap the band behind it more than it should.
- The far cast inherits the flat-floor assumption twice over: the circle is drawn on a single quad at `y = 0`, and the snare's tendrils and rim arcs are placed against that same plane. Neither would drape over a step.
- Both the targeting circle and the snare's field are additive, so the footprint brightens the floor rather than shading it. On a pale floor the boundary would need a non-additive pass under it to stay readable.

---

## Licence

[](https://github.com/achrefelouafi/LinearAbiltyCastingThreeJS/#licence)

Code is provided as-is for the purposes of this project. The bundled HDR probe and the character FBX retain their original licences.

# Mouse Following Square Lens Effect

[](https://github.com/tomoyukinakata/mouse-following-square-lens-effect#mouse-following-square-lens-effect)

An interactive WebGL effect that follows the pointer with a square lens, switching between two textures while applying lens distortion, a radial RGB shift, waves, and animated grain.

[![Mouse Following Square Lens Effect preview](https://github.com/tomoyukinakata/mouse-following-square-lens-effect/raw/master/public/assets/img/screenshot.webp)](https://github.com/tomoyukinakata/mouse-following-square-lens-effect/blob/master/public/assets/img/screenshot.webp)

[Article on Codrops](https://tympanus.net/codrops/2026/08/25/building-a-mouse-following-square-lens-effect-with-three-js-and-glsl/)

[Demo](https://tympanus.net/Tutorials/MouseFollowingSquareLensEffect/)

## Features

[](https://github.com/tomoyukinakata/mouse-following-square-lens-effect#features)

- A pointer-following square mask that remains square across viewport aspect ratios
- Localized lens distortion inside the square
- A radial RGB shift that grows stronger toward the square's edges
- Independent inside and outside textures with cover-style UV mapping
- Animated sine-wave and pseudo-random displacement outside the square
- Live controls for the lens, wave, grain, and pointer easing parameters

## Installation

[](https://github.com/tomoyukinakata/mouse-following-square-lens-effect#installation)

```shell
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview the production build locally
npm run preview

```

## Credits

[](https://github.com/tomoyukinakata/mouse-following-square-lens-effect#credits)

- Built with [Astro](https://astro.build/), [Three.js](https://threejs.org/), and [lil-gui](https://lil-gui.georgealways.com/)
- The `random3` GLSL function is based on [Nikita Miropolskiy's Shadertoy example](https://www.shadertoy.com/view/XsX3zB)
- Demo imagery uses [Red rose flower](https://unsplash.com/ja/%E5%86%99%E7%9C%9F/%E8%B5%A4%E3%81%84%E3%83%90%E3%83%A9%E3%81%AE%E8%8A%B1-Y7iHt3LRWGg) by [Kelly Sikkema](https://unsplash.com/@kellysikkema) on Unsplash

## Misc

[](https://github.com/tomoyukinakata/mouse-following-square-lens-effect#misc)

Follow yuki: [X](https://x.com/yukiloz7), [GitHub](https://github.com/tomoyukinakata)

Follow Codrops: [X](https://www.x.com/codrops), [Facebook](https://www.facebook.com/codrops), [Instagram](https://www.instagram.com/codropsss/), [LinkedIn](https://www.linkedin.com/company/codrops/), [GitHub](https://github.com/codrops)

## License

[](https://github.com/tomoyukinakata/mouse-following-square-lens-effect#license)

[MIT](https://github.com/tomoyukinakata/mouse-following-square-lens-effect/blob/master/LICENSE)

# WebGL Xylophone

[](https://github.com/Sujenphea/xylophone#webgl-xylophone)

A scrolling helix of frosted glass bars that ring as you sweep across them, built in Three.js with instancing, a fluid simulation, and glass faked entirely in the shader.

[![WebGL Xylophone Demo](https://camo.githubusercontent.com/db1ef866b1ae9c0c8dd29ac6b045a38ea43d3fb82b91cd2b4bdbcaa3e95603ba/68747470733a2f2f74796d70616e75732e6e65742f636f64726f70732f77702d636f6e74656e742f75706c6f6164732f323032362f30372f486f6d652e706e67)](https://camo.githubusercontent.com/db1ef866b1ae9c0c8dd29ac6b045a38ea43d3fb82b91cd2b4bdbcaa3e95603ba/68747470733a2f2f74796d70616e75732e6e65742f636f64726f70732f77702d636f6e74656e742f75706c6f6164732f323032362f30372f486f6d652e706e67)

[Article on Codrops](https://tympanus.net/codrops/?p=118008)

[Demo](https://tympanus.net/Tutorials/Xylophone/)

## Features

[](https://github.com/Sujenphea/xylophone#features)

- **Instanced Glass Helix**: 64 bars drawn in one call, posed entirely from instance attributes
- **Scroll Conveyor**: advancing the scroll phase wraps bars around a finite ring, so a fixed count reads as an endless column
- **Frosted Transmission**: the backdrop is rendered and Gaussian-blurred into its own buffer, then refracted through each bar with fresnel and thin-film iridescence
- **Fluid Hover Wake**: a low-res GPU fluid solve drives the colour tint, and sleeps itself when the pointer goes idle
- **GPU-Geometry Picking**: the bars exist only on the GPU, so hit testing rebuilds each instance's matrix on the CPU and tests one bounding box per bar — allocation-free, no per-triangle work
- **Polyphonic Web Audio**: one recorded sample pitch-shifted across a major-pentatonic scale, one voice per strike, with a voice cap for fast sweeps

## Development

[](https://github.com/Sujenphea/xylophone#development)

Start the development server with hot module replacement:

```shell
npm run dev
```

Open [http://localhost:5173](http://localhost:5173) in your browser.

Type-check and lint:

```shell
npm run lint
```

## Building for Production

[](https://github.com/Sujenphea/xylophone#building-for-production)

Create an optimized production build:

```shell
npm run build
```

The built files will be in the `dist/` directory. Preview the production build:

```shell
npm run preview
```

## Credits

[](https://github.com/Sujenphea/xylophone#credits)

- Fluid solver adapted from [WebGL-Fluid-Simulation](https://github.com/PavelDoGreat/WebGL-Fluid-Simulation) by Pavel Dobryakov (MIT)
- Built with [three.js](https://threejs.org/) and [postprocessing](https://github.com/pmndrs/postprocessing)

## Misc

[](https://github.com/Sujenphea/xylophone#misc)

Follow Sujen: [Twitter](https://x.com/sujen_p), [GitHub](https://github.com/Sujenphea), [Linkedin](https://www.linkedin.com/in/sujenphea/)

Follow Codrops: [X](http://www.x.com/codrops), [Facebook](https://www.facebook.com/codrops), [Instagram](https://www.instagram.com/codropsss/), [LinkedIn](https://www.linkedin.com/company/codrops/), [GitHub](https://github.com/codrops)

## License

[](https://github.com/Sujenphea/xylophone#license)

[MIT](https://github.com/Sujenphea/xylophone/blob/main/LICENSE)

## About

The Endless Glass Xylophone

### Resources

[Readme](https://github.com/Sujenphea/xylophone#readme-ov-file)

[MIT license](https://github.com/Sujenphea/xylophone#MIT-1-ov-file)

[Activity](https://github.com/Sujenphea/xylophone/activity)

### Stars

**38** stars

### Watchers

**0** watching

### Forks

[**4** forks](https://github.com/Sujenphea/xylophone/forks)

[Report repository](https://github.com/contact/report-content?content_url=https%3A%2F%2Fgithub.com%2FSujenphea%2Fxylophone&report=Sujenphea+%28user%29)

## [Releases](https://github.com/Sujenphea/xylophone/releases)

No releases published

## [Contributors](https://github.com/Sujenphea/xylophone/graphs/contributors)3 (3)

- [![@Sujenphea](https://avatars.githubusercontent.com/u/64251381?s=64&v=4)](https://github.com/Sujenphea)[**Sujenphea**Sujen Phea](https://github.com/Sujenphea)
- [![@claude](https://avatars.githubusercontent.com/u/81847?s=64&v=4)](https://github.com/claude)[**claude**Claude](https://github.com/claude)
- [![@crnacura](https://avatars.githubusercontent.com/u/1044196?s=64&v=4)](https://github.com/crnacura)[**crnacura**Manoela Ilic](https://github.com/crnacura)

## Languages

- [TypeScript73.3%](https://github.com/Sujenphea/xylophone/search?l=typescript)
- [GLSL17.2%](https://github.com/Sujenphea/xylophone/search?l=glsl)
- [CSS5%](https://github.com/Sujenphea/xylophone/search?l=css)
- [HTML2.7%](https://github.com/Sujenphea/xylophone/search?l=html)
- [JavaScript1.7%](https://github.com/Sujenphea/xylophone/search?l=javascript)
- [Makefile0.1%](https://github.com/Sujenphea/xylophone/search?l=makefile)

## Footer

[](https://github.com)© 2026 GitHub, Inc.

### Footer navigation

- [Terms](https://docs.github.com/site-policy/github-terms/github-terms-of-service)
- [Priva](https://docs.github.com/site-policy/privacy-policies/github-privacy-statement)

# False Earth

[](https://github.com/momentchan/false-earth#false-earth)

[![螢幕擷取畫面 2026-02-09 173835](https://private-user-images.githubusercontent.com/6835124/546985763-85adc859-7ab1-44e1-91db-2a9f884c00f4.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3OTI0Njg2MjIsIm5iZiI6MTc5MjQ2ODMyMiwicGF0aCI6Ii82ODM1MTI0LzU0Njk4NTc2My04NWFkYzg1OS03YWIxLTQ0ZTEtOTFkYi0yYTlmODg0YzAwZjQucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI2MTAyMCUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNjEwMjBUMDM1MjAyWiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9NGVlZDlhOTFlNzAyNjVhYTQ5MDhiM2Q5NGQ0MTA3ODAyZmFlMjNmNDM3YTlkOWI1ZmU5YjFiMGJiMDg2ZDI5ZCZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmcmVzcG9uc2UtY29udGVudC10eXBlPWltYWdlJTJGcG5nIn0.PXU49AqxGgUdqhhdBZAEuzu_dPimzWwS1zls009FnvY)](https://private-user-images.githubusercontent.com/6835124/546985763-85adc859-7ab1-44e1-91db-2a9f884c00f4.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3OTI0Njg2MjIsIm5iZiI6MTc5MjQ2ODMyMiwicGF0aCI6Ii82ODM1MTI0LzU0Njk4NTc2My04NWFkYzg1OS03YWIxLTQ0ZTEtOTFkYi0yYTlmODg0YzAwZjQucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI2MTAyMCUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNjEwMjBUMDM1MjAyWiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9NGVlZDlhOTFlNzAyNjVhYTQ5MDhiM2Q5NGQ0MTA3ODAyZmFlMjNmNDM3YTlkOWI1ZmU5YjFiMGJiMDg2ZDI5ZCZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmcmVzcG9uc2UtY29udGVudC10eXBlPWltYWdlJTJGcG5nIn0.PXU49AqxGgUdqhhdBZAEuzu_dPimzWwS1zls009FnvY)  

🔗 **[Live Demo](https://false-earth.mingjyunhung.com/)** 🔗 **[Article](https://tympanus.net/codrops/2026/04/21/false-earth-from-webgl-limits-to-a-webgpu-driven-world/)**

**False Earth** is an interactive WebGPU experience that continues the journey of [Drift](https://github.com/momentchan/drift) - presenting a continuous landscape generated in real time through GPU-based simulations.

Set after the long drift through space, the project follows an astronaut who arrives on a surface that resembles Earth, yet does not behave like one. As the astronaut moves forward, the ground responds and transforms, leaving visible traces across an endless field. Rather than telling a story through words, the experience unfolds through motion and change—where distance never closes and the environment reveals its nature only through interaction. By navigating this unfamiliar terrain, visitors encounter a world that appears stable at first glance, but gradually exposes uncertain form.

## 💡 Attribution

[](https://github.com/momentchan/false-earth#-attribution)

If you use this project in your own work, please provide credit to the author.

**Author:** Ming-Jyun Hung  
**Source:** [https://mingjyunhung.com/](https://mingjyunhung.com/)

The Astronaut model was purchased from [CGTrader](https://www.cgtrader.com/3d-models/character/sci-fi-character/astronaut-pilot).

Please do not use this asset unless you have purchased an appropriate license.

---

Built with React Three Fiber and Three.js WebGPU (TSL): GPU-computed grass, procedural terrain, VAT roses, and a playable character.

## Features

[](https://github.com/momentchan/false-earth#features)

- **WebGPU grass**: Compute shaders (TSL) for blade position, Voronoi clumping, wind, terrain sampling, and character push
- **Stable, tile-free pattern**: PCG hash for jitter and seeds (no `sin`/`mod`), CPU grid index for stable snapping
- **LOD**: Distance-based LOD with configurable segment counts and draw buffers
- **Procedural terrain**: FBM-based height and normals sampled in compute
- **VAT roses**: Vertex Animation Texture roses with LOD and compute-driven spawn/update
- **Character**: Third-person character with camera modes (Follow / FPV / Detached), grass push interaction
- **Cosmic beams**: Animated beam effects in a separate scene
- **Post-processing**: TSL pipeline with Bloom, DoF, SMAA; PerformanceMonitor for adaptive DPR

## Tech Stack

[](https://github.com/momentchan/false-earth#tech-stack)

- **React Three Fiber** – React renderer for Three.js
- **Three.js WebGPU** – WebGPU renderer and backend
- **TSL (Three Shading Language)** – Compute and vertex/fragment in TypeScript (no raw GLSL for grass)
- **Vite** – Build and dev server
- **Leva** – Debug controls
- **Zustand** – Game state (camera, character, WebGPU error, etc.)
- **r3f-perf** – Performance monitoring and DPR scaling

## Installation

[](https://github.com/momentchan/false-earth#installation)

```shell
npm install
npm run dev    # HTTPS dev server
npm run build
npm run preview
```

## Project Structure

[](https://github.com/momentchan/false-earth#project-structure)

```
src/
├── app/
│   └── App.tsx                 # Canvas, WebGPU init, PerformanceMonitor, DPR context
├── components/
│   ├── grass/                  # WebGPU procedural grass
│   │   ├── core/
│   │   │   ├── config.ts      # Blades, LOD segments, structure (data0–data3)
│   │   │   ├── grassCompute.ts # Position, Voronoi, terrain, wind, push (TSL)
│   │   │   ├── grassMaterial.ts # Vertex unpack + Bezier blade (TSL)
│   │   │   ├── grassGeometry.ts # Instance buffer, no positions buffer
│   │   │   └── shaderHelpers.ts # Bezier, wind, PCG hash (hash2to1, hash2to2)
│   │   ├── GrassWebGPU.tsx     # R3F WebGPU grass root, grid snapping
│   │   ├── GrassLOD.tsx        # LOD draw buffers and compute dispatch
│   │   └── hooks/
│   │       ├── useGrassCompute.ts
│   │       └── useGrassUniforms.ts
│   ├── Rose/                   # VAT flowers
│   │   ├── core/               # vatCompute, vatMaterial, config
│   │   ├── Rose.tsx / RoseLOD.tsx
│   │   └── hooks/
│   ├── character/              # Character mesh, physics, camera
│   ├── cosmic/                  # Beam effects
│   ├── Effects/                 # Post-processing (Bloom, DoF, SMAA)
│   ├── camera/                 # CameraViewControl, follow/FPV
│   ├── audio/                  # AudioManager, BGM, one-shot
│   ├── Terrain.tsx
│   └── DirectionalLight.tsx
├── core/
│   ├── shaders/                # Terrain, wind, uniforms (TSL helpers)
│   ├── store/                  # gameStore (Zustand)
│   ├── utils/                  # gridSnapping, DeviceDetector, etc.
│   └── input/                  # Keyboard, touch
├── ui/                         # LoadingScreen, SideBar, AudioButton, etc.
└── debug/                      # LevaWrapper, WebGPUPerf
```

## Key Components

[](https://github.com/momentchan/false-earth#key-components)

- **Grass**: Compute writes packed per-blade data (position, width/height/bend, rotation, normal, push); material reads only that buffer and builds Bezier blades. Grid snapping uses one blade spacing; CPU passes `uGridIndex` for stable seeds.
- **Terrain**: FBM height and normals; sampled in grass compute and applied to blade bases.
- **Rose**: VAT playback with compute for spawn, lifecycle, and LOD routing.
- **Effects**: TSL post pass combining main scene + beam scene (Bloom, DoF, SMAA).

## Development

[](https://github.com/momentchan/false-earth#development)

- **TypeScript** throughout
- **TSL** for all grass and effects shaders (no `vite-plugin-glsl` for grass)
- **HTTPS** for dev (required for WebGPU in many environments)
- **Path alias**: `@packages/*` for shared packages

## About

No description, website, or topics provided.

### Resources

[Readme](https://github.com/momentchan/false-earth#readme-ov-file)

[MIT license](https://github.com/momentchan/false-earth#MIT-1-ov-file)

[Activity](https://github.com/momentchan/false-earth/activity)

### Stars

**166** stars

### Watchers

**0** watching

### Forks

[**33** forks](https://github.com/momentchan/false-earth/forks)

[Report repository](https://github.com/contact/report-content?content_url=https%3A%2F%2Fgithub.com%2Fmomentchan%2Ffalse-earth&report=momentchan+%28user%29)

## [Releases](https://github.com/momentchan/false-earth/releases)

No releases published

## [Contributors](https://github.com/momentchan/false-earth/graphs/contributors)1 (1)

- [![@momentchan](https://avatars.githubusercontent.com/u/6835124?s=64&v=4)](https://github.com/momentchan)[**momentchan**](https://github.com/momentchan)

## Languages

- [TypeScript99.3%](https://github.com/momentchan/false-earth/search?l=typescript)
- [Other0.7%](https://github.com/momentchan/false-earth/search?l=Other)

## Footer

[](https://github.com)© 2026 GitHu# keleton Fluid Reveal

[](https://github.com/cullenwebber/three-skull#skeleton-fluid-reveal)

A WebGPU dual-scene fluid reveal effect built with Three.js and TSL (Three Shading Language). Instanced skeleton and human models are composited through a mouse-driven fluid simulation with bloom, scan lines, and CRT-style post-processing.

[Article on Codrops](https://tympanus.net/codrops/?p=112796)

[Demo](https://tympanus.net/Tutorials/SkeletonFluidReveal/)

## Installation

[](https://github.com/cullenwebber/three-skull#installation)

```shell
npm install
npx vite
```

## Credits

[](https://github.com/cullenwebber/three-skull#credits)

- [Three.js](https://threejs.org/)
- [maath](https://github.com/pmndrs/maath) for easing utilities

## Misc

[](https://github.com/cullenwebber/three-skull#misc)

Follow Cullen Webber: [GitHub](https://github.com/cullenwebber), [X](http://www.x.com/sinzvii)

Follow Codrops: [X](http://www.x.com/codrops), [Facebook](https://www.facebook.com/codrops), [Instagram](https://www.instagram.com/codropsss/), [LinkedIn](https://www.linkedin.com/company/codrops/), [GitHub](https://github.com/codrops)

## License

[](https://github.com/cullenwebber/three-skull#license)

[MIT](https://github.com/cullenwebber/three-skull/blob/main/LICENSE)

## About

No description, website, or topics provided.

### Resources

[Readme](https://github.com/cullenwebber/three-skull#readme-ov-file)

[Activity](https://github.com/cullenwebber/three-skull/activity)

### Stars

**48** stars

### Watchers

**0** watching

### Forks

[**5** forks](https://github.com/cullenwebber/three-skull/forks)

[Report repository](https://github.com/contact/report-content?content_url=https%3A%2F%2Fgithub.com%2Fcullenwebber%2Fthree-skull&report=cullenwebber+%28user%29)

## [Releases](https://github.com/cullenwebber/three-skull/releases)

No releases published

## [Contributors](https://github.com/cullenwebber/three-skull/graphs/contributors)2 (2)

- [![@cullenwebber](https://avatars.githubusercontent.com/u/139840023?s=64&v=4)](https://github.com/cullenwebber)[**cullenwebber**Cullen Webber](https://github.com/cullenwebber)
- [![@crnacura](https://avatars.githubusercontent.com/u/1044196?s=64&v=4)](https://github.com/crnacura)[**crnacura**Manoela Ilic](https://github.com/crnacura)

## Languages

- [JavaScript83.8%](https://github.com/cullenwebber/three-skull/search?l=javascript)
- [CSS10.6%](https://github.com/cullenwebber/three-skull/search?l=css)
- [HTML5.6%](https://github.com/cullenwebber/three-skull/search?l=html)

## Footer

[](https://github.com)© 2

# 3D Infinite Carousel with Reactive Background Gradients

[](https://github.com/clementgrellier/gradientslider#3d-infinite-carousel-with-reactive-background-gradients)

Smooth, infinite 3D carousel where each image drives a reactive, canvas-based background gradient that adapts to its colors.

[![Image Title](https://camo.githubusercontent.com/bfd7b4faec9c31bbbb87d14beb35da46e58eeaf732105da3130280f0045e895f/68747470733a2f2f74796d70616e75732e6e65742f636f64726f70732f77702d636f6e74656e742f75706c6f6164732f323032352f31312f6361726f7573656c2e6a7067)](https://camo.githubusercontent.com/bfd7b4faec9c31bbbb87d14beb35da46e58eeaf732105da3130280f0045e895f/68747470733a2f2f74796d70616e75732e6e65742f636f64726f70732f77702d636f6e74656e742f75706c6f6164732f323032352f31312f6361726f7573656c2e6a7067)

[Article on Codrops](https://tympanus.net/codrops/?p=103532)

[Demo](https://tympanus.net/Tutorials/3DGradientCarousel)

---

## Features

[](https://github.com/clementgrellier/gradientslider#features)

- 🎠 **Infinite 3D carousel**
- 🖱️ **Drag & wheel navigation**
- 🌈 **Reactive gradients**
- 🪟 **Responsive layout**
- 🎞️ **GPU-friendly animations**

---

## Demo

[](https://github.com/clementgrellier/gradientslider#demo)

Open `index.html` directly in your browser **or** serve the folder with any static server

## Replace Images

[](https://github.com/clementgrellier/gradientslider#replace-images)

Put your images inside img/

In `script.js`, update the images list:

```
const IMAGES = [
  './img/your-image-01.webp',
  './img/your-image-02.webp',
  // ...
];
```

## Customization

[](https://github.com/clementgrellier/gradientslider#customization)

Most of the behavior can be tuned via constants at the top of `script.js`

## Credits

[](https://github.com/clementgrellier/gradientslider#credits)

created by [Clément Grellier](https://clementgrellier.fr/)

## About

No description, website, or topics provided.

### Resources

[Readme](https://github.com/clementgrellier/gradientslider#readme-ov-file)

[MIT license](https://github.com/clementgrellier/gradientslider#MIT-1-ov-file)

[Activity](https://github.com/clementgrellier/gradientslider/activity)

### Stars

**66** stars

### Watchers

**0** watching

### Forks

[**9** forks](https://github.com/clementgrellier/gradientslider/forks)

[Report repository](https://github.com/contact/report-content?content_url=https%3A%2F%2Fgithub.com%2Fclementgrellier%2Fgradientslider&report=clementgrellier+%28user%29)

## [Releases](https://github.com/clementgrellier/gradientslider/releases)

No releases published

## [Contributors](https://github.com/clementgrellier/gradientslider/graphs/contributors)2 (2)

- [![@clementgrellier](https://avatars.githubusercontent.com/u/6470844?s=64&v=4)](https://github.com/clementgrellier)[**clementgrellier**Clément Grellier](https://github.com/clementgrellier)
- [![@crnacura](https://avatars.githubusercontent.com/u/1044196?s=64&v=4)](https://github.com/crnacura)[**crnacura**Manoela Ilic](https://github.com/crnacura)

## Languages

- [JavaScript79.5%](https://github.com/clementgrellier/gradientslider/search?l=javascript)
- [CSS14.2%](https://github.com/clementgrellier/gradientslider/search?l=css)
- [HTML6.3%](https://github.com/clementgrellier/gradientslider/search?l=html)

## Footer

[](https://github.com)© 2026

# Interactive, Droplet-like Metaballs with Three.js and GLSL

[](https://github.com/koji014/interactive-droplets#interactive-droplet-like-metaballs-with-threejs-and-glsl)

Demo for the tutorial on how to create interactive, droplet-like metaballs using Three.js and GLSL.

[![Interactive, droplet-like metaballs](https://github.com/koji014/interactive-droplets/raw/main/public/droplet.png)](https://github.com/koji014/interactive-droplets/blob/main/public/droplet.png)

[Article on Codrops](https://tympanus.net/codrops/2025/06/09/how-to-create-interactive-droplet-like-metaballs-with-three-js-and-glsl/)

[Demo](https://tympanus.net/Tutorials/InteractiveBubbleMetaballs/)

## Installation

[](https://github.com/koji014/interactive-droplets#installation)

1. **Clone this repository:**
    
    ```shell
    git clone https://github.com/koji014/interactive-droplets.git your-project-name
    cd your-project-name
    ```
    
2. **Install the dependencies:**
    
    ```shell
    npm install
    ```
    
3. **Start the development server:**
    
    ```shell
    npm run dev
    ```
    
4. **Create the build:**
    
    ```shell
    npm run build
    ```
    

## Credits

[](https://github.com/koji014/interactive-droplets#credits)

### Signed Distance Functions

[](https://github.com/koji014/interactive-droplets#signed-distance-functions)

- [Inigo Quilez :: computer graphics, mathematics, shaders, fractals, demoscene and more](https://iquilezles.org/articles/distfunctions/)

### Metaball Effect

[](https://github.com/koji014/interactive-droplets#metaball-effect)

- [wgld.org | GLSL: オブジェクト同士を補間して結合する](https://wgld.org/d/glsl/g016.html)
- [Inigo Quilez :: computer graphics, mathematics, shaders, fractals, demoscene and more](https://iquilezles.org/articles/smin/)

### Value Noise

[](https://github.com/koji014/interactive-droplets#value-noise)

- [The Book of Shaders: Random](https://thebookofshaders.com/10/)
- [The Book of Shaders: Noise](https://thebookofshaders.com/11/)
- [Inigo Quilez :: computer graphics, mathematics, shaders, fractals, demoscene and more](https://iquilezles.org/articles/morenoise/)

## Misc

[](https://github.com/koji014/interactive-droplets#misc)

Follow Yuki Kojima: [Twitter](https://x.com/_koji014), [GitHub](https://github.com/koji014)

Follow Codrops: [Bluesky](https://bsky.app/profile/codrops.bsky.social), [Facebook](http://www.facebook.com/codrops), [GitHub](https://github.com/codrops), [Instagram](https://www.instagram.com/codropsss/), [X](http://www.x.com/codrops)

## License

[](https://github.com/koji014/interactive-droplets#license)

This resource can be used freely if integrated or build upon in personal or commercial projects such as websites, web apps and web templates intended for sale. It is not allowed to take the resource "as-is" and sell it, redistribute, re-publish it, or sell "pluginized" versions of it. Free plugins built using this resource should have a visible mention and link to the original work. Always consider the licenses of all included libraries, scripts and images used.

## About

Interactive metaball effect with ray marching, simulating realistic water droplets that respond smoothly to mouse input.

### Resources

[Readme](https://github.com/koji014/interactive-droplets#readme-ov-file)

[Activity](https://github.com/koji014/interactive-droplets/activity)

### Stars

**41** stars

### Watchers

**0** watching

### Forks

[**15** forks](https://github.com/koji014/interactive-droplets/forks)

[Report repository](https://github.com/contact/report-content?content_url=https%3A%2F%2Fgithub.com%2Fkoji014%2Finteractive-droplets&report=koji014+%28user%29)

## [Releases](https://github.com/koji014/interactive-droplets/releases)

No releases published

## [Contributors](https://github.com/koji014/interactive-droplets/graphs/contributors)1 (1)

- [![@koji014](https://avatars.githubusercontent.com/u/122514627?s=64&v=4)](https://github.com/koji014)[**koji014**Yuki Kojima](https://github.com/koji014)

## Languages

- [TypeScript45.4%](https://github.com/koji014/interactive-droplets/search?l=typescript)
- [SCSS27.2%](https://github.com/koji014/interactive-droplets/search?l=scss)
- [GLSL16.8%](https://github.com/koji014/interactive-droplets/search?l=glsl)
- [HTML10.4%](https://github.com/koji014/interactive-droplets/search?l=html)
- [JavaScript0.2%](https://github.com/koji014/interactive-droplets/search?l=javascript)

## Footer

[](https://github.com)© 2026 GitHub, Inc.

### Footer navigation

- [Term](https://docs.github.com/site-policy/github-terms/github-terms-of-service)