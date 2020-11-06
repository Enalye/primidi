/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.particles;

import atelier;

/// Simple particle.
final class Particle  {
	Color color = Color.white;
	Vec2f position = Vec2f.zero;
    float time = 0f;
	float timeToLive = 60f;
	float angle = 0f;
	float speed = 0f;
	float angleSpeed = 0f;
    float alpha = 1f;
    Sprite sprite;

    /// Update the particle, returns true if dead.
	bool update(float deltaTime) {
		time += deltaTime;
		if(time > timeToLive && timeToLive > 0f)
			return true;

		const Vec2f direction = Vec2f(1f, 0f).rotated(angle) * speed;
		position += direction * deltaTime;
		angle += angleSpeed * deltaTime;
		
		return false;
	}

    /// Render the particle
	void draw() {
        sprite.color = color;
        sprite.alpha = alpha;
        sprite.draw(position);
	}
}

private {
    alias ParticleArray = IndexedArray!(Particle, 5000u);
    ParticleArray _particles;
}

void initializeParticles() {
    _particles = new ParticleArray;
}

void resetParticles() {
    if(!_particles)
        return;
    _particles.reset();
}

void updateParticles(float deltaTime) {
    if(!_particles)
        return;
    foreach(Particle particle, uint index; _particles) {
        if(particle.update(deltaTime))
            _particles.markInternalForRemoval(index);
    }
    _particles.sweepMarkedData();
}

void drawParticles() {
    if(!_particles)
        return;
    foreach(Particle particle; _particles)
        particle.draw();
}

Particle createParticle(Vec2f position, float angle, float speed, int timeToLive) {
    if(!_particles)
        return null;
    if((_particles.length + 1u) == _particles.capacity)
        return null;

    Particle particle = new Particle;
    particle.position = position;
    particle.angle = angle;
    particle.speed = speed;
    particle.timeToLive = timeToLive;
    particle.sprite = fetch!Sprite("texel");
    _particles.push(particle);
    return particle;
}

