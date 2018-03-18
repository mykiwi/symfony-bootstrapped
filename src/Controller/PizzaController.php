<?php

namespace App\Controller;

use App\Entity\Pizza;
use App\Form\PizzaType;
use App\Repository\PizzaRepository;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

/**
 * @Route("/pizza")
 */
class PizzaController extends Controller
{
    /**
     * @Route("/", name="pizza_index", methods="GET")
     */
    public function index(PizzaRepository $pizzaRepository): Response
    {
        return $this->render('pizza/index.html.twig', ['pizzas' => $pizzaRepository->findAll()]);
    }

    /**
     * @Route("/new", name="pizza_new", methods="GET|POST")
     */
    public function new(Request $request): Response
    {
        $pizza = new Pizza();
        $form = $this->createForm(PizzaType::class, $pizza);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($pizza);
            $em->flush();

            return $this->redirectToRoute('pizza_index');
        }

        return $this->render('pizza/new.html.twig', [
            'pizza' => $pizza,
            'form' => $form->createView(),
        ]);
    }

    /**
     * @Route("/{id}", name="pizza_show", methods="GET")
     */
    public function show(Pizza $pizza): Response
    {
        return $this->render('pizza/show.html.twig', ['pizza' => $pizza]);
    }

    /**
     * @Route("/{id}/edit", name="pizza_edit", methods="GET|POST")
     */
    public function edit(Request $request, Pizza $pizza): Response
    {
        $form = $this->createForm(PizzaType::class, $pizza);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->getDoctrine()->getManager()->flush();

            return $this->redirectToRoute('pizza_edit', ['id' => $pizza->getId()]);
        }

        return $this->render('pizza/edit.html.twig', [
            'pizza' => $pizza,
            'form' => $form->createView(),
        ]);
    }

    /**
     * @Route("/{id}", name="pizza_delete", methods="DELETE")
     */
    public function delete(Request $request, Pizza $pizza): Response
    {
        if (!$this->isCsrfTokenValid('delete'.$pizza->getId(), $request->request->get('_token'))) {
            return $this->redirectToRoute('pizza_index');
        }

        $em = $this->getDoctrine()->getManager();
        $em->remove($pizza);
        $em->flush();

        return $this->redirectToRoute('pizza_index');
    }
}
