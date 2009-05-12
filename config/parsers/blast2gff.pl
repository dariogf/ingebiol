#!/usr/bin/perl -w

# blast2gff.pl
# Antonio Jesus Lara Aparicio <ajlara@scbi.uma.es>

# POD documentation

=head1 NAME

blast2gff - Transforma un resultado blast en un fichero GFF versión 2


=head1 VERSION

SCBI blast2gff 0.7


=head1 SYNOPSIS

    # Ejecucion sobre un fichero de salida de blast
    blast2gff <blast_file> [<gff_file>] [-s] [-c] [-e <evalue>]

    Opciones:
       blast_file            Ruta del fichero blast de entrada

       gff_file              Ruta del fichero de salida gff (opcional)

       -s                    Separa la salida en un gff por blast

       -c                    Añade al gff cada contig completo

       -e evalue             Filtra la entrada blast por el valor de evalue


=head1 DESCRIPTION

Se lee un fichero blast como entrada para generar un fichero gff con los
resultados obtenidos.


=head1 AUTHOR - Antonio Jesus Lara Aparicio

Email ajlara@scbi.uma.es


=cut


# Let the code begin...

use strict;
use warnings;

use Getopt::Long;
#use Bio::Seq;
#use Bio::SeqIO;
use Bio::SearchIO;


#-----------------------------------------------------------------------------#

=head2 result_to_string

 Title   : result_to_string
 Usage   : &result_to_string($result, $offset, $completed, $evalue);
 Function: Transforma un resultado blast en una cadena de texto gff.
           Solo se añaden los hits que no esten contenidos en otro hit mejor.
 Returns : String (el resultado blast)
 Args    : Bio::Search::Result::BlastResult (resultado blast)
           int (desplazamiento de la query para saber su posicion absoluta)
           bool (si se añade o no el contig completo)
           int (evalue para el corte)

=cut

sub result_to_string {
  my ($blast_result, $offset, $completed, $evalue) = @_;
  my @hits = ();                            # lista de hits del result
  my @hsps = ();                            # lista de hsps de cada hit
  my ($hit, $hsp);                          # hit de un result, y hsp de un hit
  my ($ini, $fin);                          # inicio y fin del hsp
  my @regions = ();                         # ini y fin de un hit elegido       ([ini,fin],[ini,fin],...);
  my $procesar_hsps = 1;                    # (bool) 1 si se tienen que procesar
  my $text_result = '';                     # valor devuelto
  # elementos de cada linea del fichero gff
  my ($seqname, $source, $feature, $start, $end, $score, $strand, $frame);
  # attribute: atributos opcionales de cada linea del fichero gff
  my ($sequence, $expect);

  $seqname = $blast_result->query_name();
  $source = $blast_result->algorithm();
  $feature = 'exon';

  # se filtran los hits por expect value y se procesan los que pasen el filtro
  @hits = grep {$_->num_hsps() > 0 && $_->significance() <= $evalue} $blast_result->hits();
  foreach $hit (@hits) {
    $sequence = 'Sequence "' . $hit->name() . $hit->description() . '"';

    # se filtran los hits por expect value
    @hsps = grep {$_->significance() <= $evalue} $hit->hsps();
    # se busca si alguno de los hsps no esta contenido en otro hsp
    $procesar_hsps = 0;
    foreach $hsp (@hsps) {
      $ini = $hsp->start('query');
      $fin = $hsp->end('query');
      if (!grep {$ini >= $_->[0] && $fin <= $_->[1]} @regions) {
        # el hsp no esta contenido en ninguna region de otro hsp de un hit anterior
        $procesar_hsps = 1;
        # añade este hsp como una nueva region (ya que se va a procesar)
        push @regions, [$hsp->start('query'), $hsp->end('query')];
      }
    }
    # si uno pasa el filtro se añaden todos los hsps del hit
    if ($procesar_hsps) {
      foreach $hsp (@hsps) {
        # se saca del hsp la info necesaria para el gff
        $start = $offset + $hsp->start('query');
        $end = $offset + $hsp->end('query');
        $score = $hsp->bits();
        $strand = '.' if $hsp->strand('query') == 0;
        $strand = '+' if $hsp->strand('query') == 1;
        $strand = '-' if $hsp->strand('query') == -1;
        $frame = defined $hsp->frame() ? $hsp->frame() : '.';
        $expect = 'E_value ' . $hsp->significance();
        $text_result .= "$seqname\t$source(".$hit->accession().")\t$feature\t"
                      . "$start\t$end\t$score\t$strand\t$frame\t"
                      . "$sequence; $expect\n";
      }
    }
  }

  if ($completed) {
    $text_result .= "$seqname\t".$seqname."\tgene\t"
                  . "$offset\t".($offset+($blast_result->query_length()))
                  . "\t10\t+\t0\t\n";
  }

  return $text_result;
} #result_to_string


#-----------------------------------------------------------------------------#

# main
my $uso = "uso: $0 [-s] [-c] [-e <evalue>] <blast_file> [<gff_file_prefix>]\n"
        . "-?, --help muestran la ayuda.\n";
my $splited = 0;      # si se separan los gff en diferentes ficheros
my $completed = 0;    # si se completa el gff con el propio contig
my $evalue = '1e-12'; # valor de corte

my $result = GetOptions('s' => \$splited,
                        'c' => \$completed,
                        'e:f' => \$evalue)
  or die $uso;

my ($blast_file, $gff_file) = @ARGV;
defined $blast_file or die $uso;
defined $gff_file or $gff_file = "result";

my $gff_out; # fh del fichero gff de salida
my $ini;     # offset para encadenar los query de los blast
my ($query, $filename);

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;

# genera la la cabecera
my $header = "##gff-version 2\n"
           . "##source-version SCBI:blast2gff 0.7\n"
           . "##date $year-$mon-$mday\n"
           . "\n";

# handle del fichero blast de entrada
my $searchio_in = Bio::SearchIO->new(-file => $blast_file, -format => 'blast');

if (!$splited) {
  # handle del fichero gff de salida
  open $gff_out, ">$gff_file" or die "Cannot open >$gff_file";
}

$ini = 0;
while (my $result = $searchio_in->next_result()) {
  if ($splited) {
    # handle del fichero gff de salida
    $query = $result->query_name();
    $filename = "$gff_file.$query.gff";
    open $gff_out, ">$filename" or die "Cannot open >$gff_file";
    print $gff_out $header;
  }
  
  print $gff_out result_to_string($result, $ini, $completed, $evalue);
  $ini += $result->query_length() +1;

  if ($splited) {
    close $gff_out;

    system("gff2ps -a $filename > $filename.ps 2>> $gff_file.log")
      or die "ERROR: gff2ps";
  }
}
if (!$splited) {
  close $gff_out;

  system("gff2ps -a $gff_file > $gff_file.ps 2>> $gff_file.log")
    or die "ERROR: gff2ps";
}

1;

