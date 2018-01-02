<?php

namespace App\DataFixtures;

use App\Entity\Foo;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Common\Persistence\ObjectManager;

class FooFixtures extends Fixture
{
    public function load(ObjectManager $manager)
    {
        for ($i = 0; $i < 20; $i++) {
            $foo = new Foo();
            $foo->setBar('bar '.$i);
            $manager->persist($foo);
        }

        $manager->flush();
    }
}
