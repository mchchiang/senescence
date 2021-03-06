/* VanillaNorm.cpp
 *
 * A program that reads in a contact matrix in the format
 * (bin_i bin_j count_ij) (full or upper triangle) and
 * performs the square root vanilla normalisation on the matrix.
 *
 * The square root vanilla normalisation procedure is as follows:
 * M_ij* = M_ij/sqrt(sum_k M_kj * sum_l M_il)
 * For references, see Rao et al. Cell (1509) 1665-1680, 2014
 *
 */

#include <iostream>
#include "ContactMapLib.hpp"

using std::cout;
using std::endl;
using std::string;
using std::vector;
using std::ifstream;
using std::ofstream;
using std::istringstream;


int main(int argc, char* argv[]){

  // Read in arguments
  if (argc < 5){
    cout << "Not enough arguments!" << endl; 
    cout << "Usage ./VanillaNorm [size] [full/upper] "
	 << " [input] [output]" << endl;
    return 1;
  }
  int argi {};
  int size {stoi(string(argv[++argi]), nullptr, 10)};
  string mode (argv[++argi]);
  string matrixFile (argv[++argi]);
  string normFile (argv[++argi]);

  bool full = true;
  if (mode != "full") full = false;

  CMap map = ContactMap::createFromMatrixFile(size, full, matrixFile);
  map->vanillaNorm();
  map->exportToFile(true, true, true, normFile);
}
