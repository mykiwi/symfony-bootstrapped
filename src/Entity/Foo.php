<?php

namespace App\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity
 * @ORM\Table("foo")
 */
class Foo
{
    /**
     * @ORM\Id
     * @ORM\Column(type="integer")
     * @ORM\GeneratedValue
     */
    private $id;

    /**
     * @ORM\Column(type="string", length=42)
     */
    private $bar;

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getBar(): ?string
    {
        return $this->bar;
    }
    
    public function setBar(string $bar): void
    {
        $this->bar = $bar;
    }
}
