<?php

/*
 * This file is part of the appname project.
 *
 * (c) Romain Gautier <mail@romain.sh>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace App\DataFixtures;

use App\Entity\Pizza;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Common\Persistence\ObjectManager;

class PizzaFixtures extends Fixture
{
    public function load(ObjectManager $manager)
    {
        for ($i = 0; $i < 20; ++$i) {
            $pizza = new Pizza();
            $pizza->setName('Pizza '.$i);
            $manager->persist($pizza);
        }

        $manager->flush();
    }
}
