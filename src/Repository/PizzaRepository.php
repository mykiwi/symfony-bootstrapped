<?php

/*
 * This file is part of the appname project.
 *
 * (c) Romain Gautier <mail@romain.sh>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace App\Repository;

use App\Entity\Pizza;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Common\Persistence\ManagerRegistry;

/**
 * @method Pizza|null find($id, $lockMode = null, $lockVersion = null)
 * @method Pizza|null findOneBy(array $criteria, array $orderBy = null)
 * @method Pizza[]    findAll()
 * @method Pizza[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class PizzaRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Pizza::class);
    }
}
