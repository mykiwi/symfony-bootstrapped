<?php

namespace App\Controller;

use App\Entity\Foo;
use Symfony\Bridge\Doctrine\RegistryInterface;
use Symfony\Component\HttpFoundation\Response;
use Twig\Environment;

class HomepageController
{
    public function index(RegistryInterface $doctrine, Environment $twig): Response
    {
        $entities = $doctrine->getRepository(Foo::class)->findAll();

        return new Response($twig->render('homepage.html.twig', [
            'entities' => $entities,
        ]));
    }
}
