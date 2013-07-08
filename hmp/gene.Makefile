all: basic_hmmgs.txt align cdhit primer_summary.txt

.PHONY: align cdhit

basic_hmmgs.txt: $(BLOOM)
	java -Xmx3g -jar $(JAR_DIR)/hmmgs.jar basic 1 $(BLOOM) for_enone.hmm rev_enone.hmm ref_aligned.faa > basic_hmmgs.txt 2> hmmgs.stderr

primer_summary.txt: align basic_hmmgs.txt
	python2.7 ../../scripts/primer_check.py primer_details.txt aligned_nucl_cdhit.fasta 2 > primer_summary.txt 2> primer_summary.stderr

ref_aligned.faa_prot.fasta: basic_hmmgs.txt
ref_aligned.faa_nucl.fasta: basic_hmmgs.txt

align: aligned_prot.fasta aligned_nucl.fasta aligned_nucl_cdhit.fasta

aligned_prot.sto: ref_aligned.faa_prot.fasta
	hmmalign --allcol -o aligned_prot.sto for_enone.hmm ref_aligned.faa_prot.fasta

aligned_prot.fasta: aligned_prot.sto
	java -cp $(JAR_DIR)/ReadSeq.jar edu.msu.cme.rdp.readseq.ToFasta aligned_prot.sto > aligned_prot.fasta || rm aligned_prot.fasta

aligned_nucl.fasta: aligned_prot.fasta ref_aligned.faa_nucl.fasta
	java -cp $(JAR_DIR)/FungeneUtils.jar edu.msu.cme.rdp.fungene.cli.AlignNuclCmd aligned_prot.fasta ref_aligned.faa_nucl.fasta aligned_nucl.fasta /dev/null

cdhit: prot_cdhit.fasta nucl_cdhit.fasta

nucl_cdhit.fasta: ref_aligned.faa_nucl.fasta
	cd-hit-est -i ref_aligned.faa_nucl.fasta -o nucl_cdhit.fasta -c .95

prot_cdhit.fasta: ref_aligned.faa_prot.fasta
	cd-hit -i ref_aligned.faa_prot.fasta -o prot_cdhit.fasta -c .90

aligned_nucl_cdhit.fasta: aligned_prot.fasta nucl_cdhit.fasta
	java -cp $(JAR_DIR)/FungeneUtils.jar edu.msu.cme.rdp.fungene.cli.AlignNuclCmd aligned_prot.fasta nucl_cdhit.fasta aligned_nucl_cdhit.fasta /dev/null

clean:
	-rm *.fasta *.sto *.clstr primer_summary.txt *.stderr basic_hmmgs.txt
